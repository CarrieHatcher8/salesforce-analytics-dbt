### Business Rules and Metric Definitions

I built this project around a very simple, human idea: the numbers we use to talk about our business should be clear, easy to trace, and fair to the teams creating them. Everyone should know exactly what a number means, where it came from, and the precise moment in time it counts. 

I also wanted to make life easier for our analytics team by keeping business logic out of the BI layer. Whether someone is building in Tableau or another reporting tool, they should be able to just use these models directly, without having to recreate complex rules for Bookings, Revenue, or Cash Collected from scratch. 

### Bookings

For this project, we consider a Booking to happen when a contract is officially executed. 

To keep things consistent, I’m using the contract execution date provided by Finance rather than relying on Salesforce Opportunity stages. Sales teams move incredibly fast and are focused on closing deals, so it’s completely natural for pipeline stages to lag behind reality. Using the Finance date gives us a solid, unified source of truth. 

A contract counts as a Booking when: 

* The contract status is set to EXECUTED
* The contract has a valid execution date

The total value of the contract is counted entirely in the month it was executed. For example, if a $400,000 contract is signed in March, March gets the full $400,000 Booking. We don’t repeat or split that value into April, May, or future months. 

This is incredibly helpful for anyone building reports because a BI user can simply SUM Bookings across months, quarters, or years without worrying about accidentally overstating the numbers or double-counting a deal. 

### Recognized Revenue

Bookings and Revenue are intentionally treated as two different milestones, reflecting the different stages of our customer relationships. 

A contract might be fully booked in one month, but the actual work—and the revenue we earn from it—is recognized over several months. Because of this, Recognized Revenue comes straight from the Finance data and maps directly to the specific accounting period in which the revenue was recognized. 

Before any revenue record reaches the final reporting layer, the pipeline validates that its matching contract actually exists in our system. If it doesn't, we don't want to just drop the record and forget about it, but we also don't want to include it in our official numbers quite yet. The record is set aside so we can investigate the mismatch without losing track of the data. 

### Cash Collected

Cash Collected represents the actual payment event. The date we receive the funds is the date the cash is counted. 

Keeping these three events separate helps us tell a clear story about how money moves through our business: 

* **Bookings** = What we contracted to do
* **Recognized Revenue** = The value we have earned
* **Cash Collected** = The payments we have received

Over time, these numbers can be reconciled, but keeping them distinct ensures we don't confuse different types of business activity. 

### Contract Performance

Our main analytical model is fct_contract_performance_monthly. 

To make it as flexible as possible, I designed its grain to be **one contract × one reporting month**. 

This gives our BI team enough detail to look at performance by individual month, customer, contract, or any available Salesforce attributes, while still allowing users to easily roll the data up into quarterly, annual, or executive views. 

To build this model safely, Bookings, Recognized Revenue, and Cash Collected are aggregated completely independently before they are joined together. This avoids a classic data engineering trap where joining transactions at different levels of detail accidentally duplicates dollars and throws off the totals. 

### Customer Identity Across Systems

Salesforce and Finance naturally use different customer IDs because they serve different purposes. To help these systems talk to each other, I created a cross-reference map that bridges the two formats: 

ACC001 + FIN-C001 → ACC001-FIN-C001 

I made sure to keep the original source IDs alongside this new key. When a number looks a little unusual, we want our analysts to be able to trace it back to the original systems without any frustration. 

We also don't assume that every Finance customer must already exist in Salesforce. A Finance-only contract can be completely legitimate, so the model preserves these records rather than cutting them out with an inner join. This allows us to spot any missing mappings together as a team without losing track of valid financial activity. 

### Dealing with Data Imperfections (And Helping Each Other Fix Them)

I intentionally included a few imperfect records in the demo dataset. In the real world, data is entered by busy people doing their best, and sometimes things just get misaligned. Clean data looks nice in a demo, but it doesn't show how a pipeline can support the team when mistakes happen. 

For instance, I added a contract that is still marked PENDING but accidentally has an execution date filled in. I also included a revenue record tied to a contract number that hasn't been created in the system yet. These aren't pipeline failures; they're data-quality exceptions that happen when teams and systems are moving quickly. 

Instead of letting these errors crash the system or quietly slip into the final dashboards to confuse our stakeholders, the pipeline catches these exceptions and routes them out of the official KPIs while keeping the data available for investigation. 

If you want to see what needs attention, the exceptions are exposed through dedicated data-quality models: dq_booking_exceptions and dq_revenue_exceptions. 

My approach here is simple and supportive: **Detect → Classify → Quarantine → Expose → Continue.** 

I don't think an honest data-entry mistake should stall the whole company's reporting for the day. At the same time, we don't want to accidentally pass unverified numbers up to leadership. This setup keeps the valid data moving forward so the business can run, keeps the exceptions visible so nobody forgets about them, and gives us a clear path to figure out what happened and help the source team get it corrected.