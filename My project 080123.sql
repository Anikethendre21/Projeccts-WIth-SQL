---Cleaning Data In SQL querles

select * from housing;

-----------------------------------------------------------


---Standardize Date Format

select saledateconverted,convert(date,Saledate) 
from Housing

update Housing
set SaleDate = convert(date,Saledate) 

alter table housing
add saledateconverted date;

update Housing
set saledateconverted = CONVERT(date,SaleDate)

-------------------------------------------------

---Populate property address data

select * from Housing
where PropertyAddress is null


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL (a.propertyaddress,b.PropertyAddress)
from Housing a join Housing b 
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null


update a---Housing
set PropertyAddress = ISNULL (a.propertyaddress,b.PropertyAddress)
from Housing a join Housing b 
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null

---------------------------------------------------------------------------


---Breaking out address into individual colums (add, city,state)

select Housing.PropertyAddress from Housing

select 
SUBSTRING(propertyaddress, 1, CHARINDEX (',',propertyaddress)-1)as address,
SUBSTRING(propertyaddress, CHARINDEX (',',propertyaddress)+1,len(propertyaddress))as address
from Housing

alter table housing
add propertysplitaddress nvarchar(255);

update Housing set
PropertyAddress = SUBSTRING(propertyaddress,1,charindex(',',PropertyAddress)-1)

alter table housing 
add propertysplitcity nvarchar(255);

update Housing set 
propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX (',',propertyaddress)+1,len(propertyaddress))

select * from Housing

select owneraddress from Housing