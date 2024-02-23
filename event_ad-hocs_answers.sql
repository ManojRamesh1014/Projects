/*
1. Provide a list of products with a base price greater than 500 and 
that are featured in promo type of 'BOGOF' (Buy One Get One Free). 
This information will help us identify high-value products that are 
currently being heavily discounted, which can be useful for evaluating 
our pricing and promotion strategies.
*/


with pname as(
select 
		product_code, 
		product_name 
from 
		products
)
select 
		distinct e.product_code, 
		pn.product_name, 
		e.base_price, 
		e.promo_type
from 
		events e
join 
		pname pn
on 
		pn.product_code = e.product_code
where 
		e.base_price > 500 and e.promo_type = 'BOGOF'
order by 
		e.base_price;

/*
High-Value Products with BOGOF Promotion Type: The query filters products 
with a base price greater than 500 and that are featured in the 'BOGOF' promo type.
*/


/*
2.Generate a report that provides an overview of the number of stores
in each city. The results will be sorted in descending order of store counts,
allowing us to identify the cities with the highest store presence. The 
report includes two essential fields: city and store count, which will 
assist in optimizing our retail operations.
*/


select 
		city, 
		count(store_id) store_count
from 
		store
group by 
		city
order by 
		store_count desc;

/*
Overview of Store Counts in Each City: This query counts the number 
of stores in each city and presents them in descending order of store count.
*/


/*
3.Generate a report that displays each campaign along with the total 
revenue generated before and after the campaign? The report includes 
three key fields: campaign _name, total revenue(before_promotion), total 
revenue(after_promotion). This report should help in evaluating the 
financial impact of our promotional campaigns. (Display the values in 
millions)
*/


with rev_cal as( 
select 
		base_price * quantity_sold_before_promo rev_bef_promo, 
		base_price * quantity_sold_after_promo rev_aft_promo
from 
		events
)
select 
		round(cast(sum(rev_bef_promo) / 1000000 as numeric),2) rev_before_promo,
		round(cast(sum(rev_aft_promo) / 1000000 as numeric),2) rev_after_promo,
		round(cast((sum(rev_bef_promo) + sum(rev_aft_promo)) / 1000000 as numeric),2) total_rev
from 
		rev_cal;

/*
Total Revenue Before and After Promotion: The query calculates the total revenue before
and after promotion, and displays the values in millions.
*/


/*
4.Produce a report that calculates the Incremental Sold Quantity (ISU%) 
for each category during the Diwali campaign. Additionally, provide 
rankings for the categories based on their ISU%. The report will include
three key fields: category, isu%, and rank order. This information will
assist in assessing the category-wise success and impact of the Diwali 
campaign on incremental sales.
Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the 
percentage increase/decrease in quantity sold (after promo) compared to 
quantity sold (before promo)
*/


--PRODUCT wise ISU% (Incremental Sold Quantity Percentage) during Diwali

with camp_name as(
select 
		campaign_id,
		campaign_name 
from 
		campaign
),
qty_sold as(
select 
		pd.product_name product_name,cn.campaign_name campaign_name,
		sum(e.quantity_sold_before_promo) sold_before_promo,
		sum(e.quantity_sold_after_promo) sold_after_promo,
		sum(e.quantity_sold_after_promo)-sum(e.quantity_sold_before_promo) sales_diff
from 
		events e 
join 
		camp_name cn
on 
		cn.campaign_id = e.campaign_id
join 
		products pd
on 
		pd.product_code = e.product_code
where 
		cn.campaign_name = 'Diwali'
group by 
		product_name,campaign_name
)
select 
		product_name,
		campaign_name,
		sold_before_promo, 
		sold_after_promo, 
		sales_diff,
		ROUND(sales_diff::NUMERIC / sold_before_promo::NUMERIC * 100, 2) Incre_S_Q_Percent
from 
		qty_sold;


--Total ISU% (Incremental Sold Quantity Percentage) during Diwali

with camp_name as(
select 
		campaign_id,
		campaign_name 
from
		campaign
),
qty_sold as(
select 
		sum(e.quantity_sold_before_promo) sold_before_promo,
		sum(e.quantity_sold_after_promo) sold_after_promo,
		sum(e.quantity_sold_after_promo)-sum(e.quantity_sold_before_promo) sales_diff
from 
		events e
join 
		camp_name cn
on 
		cn.campaign_id = e.campaign_id
where 
		cn.campaign_name = 'Diwali'
)
select 
		sold_before_promo, 
		sold_after_promo, 
		sales_diff,
		ROUND(sales_diff::NUMERIC / sold_before_promo::NUMERIC * 100, 2) Incre_S_Q_Percent
from 
		qty_sold

/*
Incremental Sold Quantity (ISU%) During Diwali Campaign: The query calculates the
Incremental Sold Quantity Percentage (ISU%) for each product during the Diwali campaign. 
It provides a comparison of quantity sold before and after the promotion, and calculates
the percentage increase or decrease.
*/



/*
5.Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage
(IR%), across all campaigns. The report will provide essential information including 
product name, category, and ir%. This analysis helps identify the most successful products
in terms of incremental revenue across our campaigns, assisting in product optimization.
*/



with rev_cal as( 
select 		
			product_code,
			campaign_id,
			base_price * quantity_sold_before_promo rev_bef_promo, 
			base_price * quantity_sold_after_promo rev_aft_promo
from 
			events
),
Temp_table as(
select
			pd.product_name product_name,
			c.campaign_name campaign_name,
			cast(sum(rc.rev_bef_promo) as numeric) rev_before_promo,
			cast(sum(rc.rev_aft_promo) as numeric) rev_after_promo,
			cast(sum(rc.rev_aft_promo) as numeric) - cast(sum(rev_bef_promo) as numeric) rev_diff,
			round(((cast(sum(rc.rev_aft_promo) as numeric) - cast(sum(rc.rev_bef_promo) as numeric)) / cast(sum(rc.rev_bef_promo) as numeric)) * 100,2) IR_percentage 
from 
			rev_cal rc
join
			products pd
on
			pd.product_code = rc.product_code
join
			campaign c
on
			c.campaign_id = rc.campaign_id
group by
			product_name,
			campaign_name
),
rank_order as
(
select 
			*, 
       		 Row_number() OVER (ORDER BY IR_percentage DESC) AS rank_order
from 
			temp_table
)
select 
			product_name,
   			campaign_name,
    		rev_before_promo,
    		rev_after_promo,
    		rev_diff,
    		IR_percentage,
    		rank_order
from
    		rank_order
where
    		rank_order <= 5;

