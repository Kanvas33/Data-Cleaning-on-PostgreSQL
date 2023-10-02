--Create tables in order to import CSV file
--Change "," to "." on CSV, to be accepeted as an INT and do importing successfully
create table nashville_housing (
    UniqueID INT PRIMARY KEY,
    ParcelID VARCHAR(50),
    LandUse VARCHAR(50),
    PropertyAddress VARCHAR(255),
    SaleDate DATE,
    SalePrice NUMERIC(12, 2),
    LegalReference VARCHAR(255),
    SoldAsVacant VARCHAR(3),
    OwnerName VARCHAR(255),
    OwnerAddress VARCHAR(255),
    Acreage NUMERIC(8, 2),
    TaxDistrict VARCHAR(50),
    LandValue NUMERIC(12, 2),
    BuildingValue NUMERIC(12, 2),
    TotalValue NUMERIC(12, 2),
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT
);


select * from nashville_housing;


--Fetching top 1.000 rows, in order to do quick analisis on the dataset
select *  from nashville_housing
limit 1000;

----------------------------------------------------------------------------
------------------ CLEANING DATA IN SQL ------------------------------------
----------------------------------------------------------------------------


-----POPULATE "propertyaddress" DATA WHERE THE VALUE IS "NULL"-----
--It can be populated properly if there is a reference point("PARCELID")

select propertyaddress from nashville_housing
where propertyaddress is NULL;


select * from nashville_housing
where propertyaddress is NULL;

--After a quick research I found out that the "parcelid" can be used as reference point, 
--Once the "parcelid" has the same "propertyaddress" in common
select uniqueid, propertyaddress, parcelid from nashville_housing
order by parcelid;

-- Select the "parcelid" from table a.
-- Select the "propertyaddress" from table a as old_propertyaddress.
-- Select the "propertyaddress" from table b as new_propertyaddress.
select
a.parcelid, -- Select "parcelid" from table a
a.propertyaddress as old_propertyaddress, -- Select "propertyaddress" from table a and alias it as old_propertyaddress
b.propertyaddress as new_propertyaddress -- Select "propertyaddress" from table b and alias it as new_propertyaddress
from nashville_housing as a -- Alias for table a
join nashville_housing as b -- Alias for table b
on a.parcelid = b.parcelid -- Join the two tables on the "parcelid" column
where a.propertyaddress is NULL -- Filter rows where "propertyaddress" is "NULL" in table a
and b.propertyaddress is not NULL; -- Filter rows where "propertyaddress" is NOT "NULL" in table b
  
-- Update "propertyaddress" where "propertyaddress" is NULL and "parcelid" matches
update nashville_housing as a -- Alias for the target table to be updated
set propertyaddress = b.propertyaddress -- Update the "propertyaddress" column with the value from the other instance of the table
from nashville_housing as b -- Alias for the source table from which we'll retrieve the "propertyaddress"
where a.propertyaddress is NULL -- Filter rows where "propertyaddress" is "NULL" in the target table
and a.parcelid = b.parcelid; -- Match rows based on "parcelid" between the target and source table

--In the case the "parcelid" is different, and does not match with the address
--"no address informed" is be inserted in the "propertyaddress"
update nashville_housing
set propertyaddress ='NO ADSRESS INFORMED'
WHERE propertyaddress is null;

--correcting, and updating the typo made above.
update nashville_housing
set propertyaddress = 'no address informed'
where propertyaddress= 'NO ADSRESS INFORMED';

--query in order to validate the update
select uniqueid, parcelid,propertyaddress from nashville_housing
where propertyaddress = 'no address informed';


-----BREAKING OUT "OWNERADDRESS" INTO INDIVIAUL COLUMNS(STATE, CITY, STREET)-----
select owneraddress from nashville_housing;


--The code is splitting the "owneraddress" column from the "nashville_housing" table by periods ('.') and replacing commas (',') with periods.
--Splitting into state column
select split_part(replace(owneraddress, ',', '.'), '.', 3) AS address_state
from nashville_housing;
--Splitting into city column
select split_part(replace(owneraddress, ',', '.'), '.', 2) AS address_city
from nashville_housing;
--Splitting into street column
select split_part(replace(owneraddress, ',', '.'), '.', 1) AS address_street
from nashville_housing;

--Create new column "address_state"
alter table nashville_housing
add address_state varchar(255);
--Update new "address_state" column with splitted state info from "owneraddress" column
update nashville_housing
set address_state = split_part(replace(owneraddress, ',', '.'), '.', 3)

--Create new column "address_city"
alter table nashville_housing
add address_city varchar(255);
--Update new "address_city" column with splitted city info from "owneraddress" column
update nashville_housing
set address_city = split_part(replace(owneraddress, ',', '.'), '.', 2)

--Create new column "address_street"
alter table nashville_housing
add address_street varchar(255);
--Update new "address_street" column with splitted street info from "owneraddress" column
update nashville_housing
set address_street = split_part(replace(owneraddress, ',', '.'), '.', 1)

--Finding "address_state", "address_city" and "address_street" on" nashville_housing" where the value is not null
select * from nashville_housing
where address_state is not null and address_city is not null 
and address_street is not null;


-----CHANGE "Y" AND "N" TO "Yes" AND "No" IN "soldasvacant" column FIELD-----

--Exploratory analysis
select distinct soldasvacant, --retrieves unique values from the "soldasvacant" column.
count(soldasvacant) --calculates the count of occurrences for each distinct value.
from nashville_housing
group by soldasvacant --organizes the results by distinct values in the "soldasvacant" column.
order by  2; --sorts the results in ascending order of the count of occurrences.

--Retrieve the info before update the database
select soldasvacant ,
case 
when soldasvacant ='Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end
from nashville_housing;

--Updating "Y" AND "N" TO "Yes" AND "No" IN "soldasvacant" column FIELD
update nashville_housing
set soldasvacant = case 
when soldasvacant ='Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end;


-----REMOVE DUPLICATES-----

-- Create a Common Table Expression (CTE) named "DuplicatesCTE"
-- Calculate a row_count for each row based on the specified columns to identify duplicates.
with DuplicatesCTE AS (
  select *,
         count(*) over (partition by  --if the information in different columns are the same, it will assume that the data is duplicated.
						parcelid, 
						propertyaddress, 
						saleprice, 
						saledate, 
						legalreference) as row_count
  from nashville_housing
)

-- Retrieve rows from the "Duplicates" CTE where the row_count is greater than 1.
select *
from DuplicatesCTE
where row_count > 1;


--Deleting duplicates
with DuplicatesCTE AS (
  select *,
         count(*) over (partition by  
						parcelid, 
						propertyaddress, 
						saleprice, 
						saledate, 
						legalreference) as row_count
  from nashville_housing
)
-- Delete rows from the original "nashville_housing" table where duplicates are identified.
delete from nashville_housing
where (parcelid, propertyaddress, saleprice, saledate, legalreference) in (
  select parcelid, propertyaddress, saleprice, saledate, legalreference
  from DuplicatesCTE
  where row_count > 1
);



-----DELETE UNUSED COLUMNS-----

--Deleting "owneraddress" once the data cleaning was done(diving into 3 columns: state, city, street), and I don't need this column anymore.
alter table nashville_housing
drop column owneraddress;

select * from nashville_housing;


-----DATABASE BACKUP-----

--Open pgAdmin: 
--Launch pgAdmin and connect to the PostgreSQL server where the database is hosted.

--Navigate to the Database: 
--In the left panel of pgAdmin, expand the server node, then expand the "Databases" node to view the list of databases on that server. 
--Locate and select the database wanted to back up.

--Initiate the Backup:
--Right-click on the selected database.
--From the context menu, choose "Backup.












