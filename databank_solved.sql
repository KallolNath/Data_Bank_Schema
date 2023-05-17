



 SELECT * from customer_nodes;
 select * from customer_transactions;
 select * from regions;
 
 ## 1. How many different nodes make up the Data Bank network?
 
 select count(distinct node_id) as unique_nodes from customer_nodes;
 
 ## 2. How many nodes are there in each region?
 
 select r.region_id,r.region_name, count(c.node_id) as no_of_nodes 
 from customer_nodes as c  inner join regions as r
 on c.region_id = r.region_id
 group by region_id;
 
 
 ## 3. How many customers are divided among the regions?
 
select r.region_id,r.region_name, count(distinct c.customer_id) as no_of_customers
 from customer_nodes as c  inner join regions as r
 on c.region_id = r.region_id
 group by region_id;
 
 ## 4. Determine the total amount of transactions for each region name
 
 select r.region_name,sum(t.txn_amount) as total_transactions
 from regions as r inner join customer_nodes as c
 on r.region_id = c.region_id
 inner join customer_transactions as t
 on c.customer_id = t.customer_id
 group by region_name;
 
 
 
 
 
 ## 5. How long does it take on an average to move clients to a new node?
 
 select round(avg(datediff(end_date,start_date)),2) as avg_days
 from customer_nodes
 where end_date != "9999-12-31";
 
 
 ## 6. What is the unique count and total amount for each transaction type?
 
 select txn_type, count(*) as unique_count, sum(txn_amount) as total_amount
 from customer_transactions
 group by txn_type;
 
 
 
 ## 7. What is the average number and size of past deposits across all customers?
 
 
 select round(count(customer_id)/(select count(distinct customer_id)
 from customer_transactions)) as average_deposit_amount
 from customer_transactions
 where txn_type = "deposit";
 
 
 
  select round(count(customer_id)/(count(distinct customer_id))) as average_deposit_amount
 from customer_transactions
 where txn_type = "deposit";
 
 
 
 
## 8. For each month - how many Data Bank customers make more than 1 deposit and at least either 1 purchase or 1 withdrawal in a single month?

with transaction_count_per_month_cte as
(
select customer_id, month(txn_date) as txn_month, monthname(txn_date) as month_name,
sum(if(txn_type = "deposit",1,0)) as deposit_count,
sum(if(txn_type = "withdrawl",1,0)) as withdrawl_count,
sum(if(txn_type = "purchase",1,0)) as purchase_count
from customer_transactions
group by customer_id, month(txn_date)
)select txn_month,month_name,count(distinct customer_id) as customer_count
from transaction_count_per_month_cte
where deposit_count>1 and
purchase_count = 1 or 
withdrawl_count = 1
group by txn_month
 ;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 