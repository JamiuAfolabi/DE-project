select *
from ny_taxi
limit 100;

select *
from zones;

-- PULocationID - ny_taxi
-- LocationID - zones
------------------------Select using Where----------------------------------------
select 
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	concat(pl."Borough", '/' ,pl."Zone" ) as pickup_location,
	concat(dl."Borough", '/' ,dl."Zone" ) as dropoff_location
from
	ny_taxi n,
	zones dl,
	zones pl
where
	1=1 and
	n."PULocationID" = pl."LocationID" and
	n."DOLocationID" = dl."LocationID"
limit
	100
------------------------Select using JOIN-------------------------------------------------	
select 
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	concat(pl."Borough", '/' ,pl."Zone" ) as pickup_location,
	concat(dl."Borough", '/' ,dl."Zone" ) as dropoff_location
from
	ny_taxi n LEFT JOIN zones dl
	ON
		n."DOLocationID" = dl."LocationID"	
	LEFT JOIN zones pl
	ON
		n."PULocationID" = pl."LocationID"
limit
	100
	
----------------------Group By Clause-----------------------------------------

select 
	CAST(tpep_dropoff_datetime AS DATE) as "Day",
	concat(pl."Borough", '/' ,pl."Zone" ) as pickup_location,
	count(tpep_dropoff_datetime),
	MAX(total_amount)
	--concat(pl."Borough", '/' ,pl."Zone" ) as pickup_location,
	--concat(dl."Borough", '/' ,dl."Zone" ) as dropoff_location
from
	ny_taxi n LEFT JOIN zones dl
	ON
		n."DOLocationID" = dl."LocationID"	
	LEFT JOIN zones pl
	ON
		n."PULocationID" = pl."LocationID"
GROUP BY
	CAST(tpep_dropoff_datetime AS DATE),
	2
ORDER BY
	"Day" ASC
