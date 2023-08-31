

---CLEANING DATA USING SQL QUERIES

select * from project1..Nashvillehousing


-- Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
from project1.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
add SaleDateConverted Date;

update project1.dbo.Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populate Property Address data

select *
from project1.dbo.Nashvillehousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress , b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress ,b.PropertyAddress)
from project1.dbo.Nashvillehousing a
join project1.dbo.Nashvillehousing b
  on a.ParcelID = b.ParcelID 
  and a.[UniqueID]<> b.[UniqueID]
  where a.PropertyAddress is NULL
 
 update a
 set PropertyAddress=ISNULL(a.PropertyAddress ,b.PropertyAddress)
 from project1.dbo.Nashvillehousing a
join project1.dbo.Nashvillehousing b
  on a.ParcelID = b.ParcelID 
  and a.[UniqueID]<> b.[UniqueID]
  where a.PropertyAddress is NULL


  --Breaking Address into Individual Columns(Address,City,State)

  select PropertyAddress
   from project1.dbo.Nashvillehousing

   select 
   SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress ) -1) as Address
   ,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress ) +1 ,len(PropertyAddress)) as Address
   from project1.dbo.Nashvillehousing

   alter table project1.dbo.Nashvillehousing
   Add Propertysplitaddress nvarchar(255);

   update project1.dbo.Nashvillehousing
   set Propertysplitaddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress ) -1)
   
   alter table project1.dbo.Nashvillehousing
   Add Propertysplitcity nvarchar(255);


   update project1.dbo.Nashvillehousing
   set Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress ) +1,LEN(PropertyAddress))


   select * from project1..Nashvillehousing

--Changing OwnerAddress

select OwnerAddress from project1..Nashvillehousing

SELECT
PARSENAME(replace(OwnerAddress,',','.'), 3),
PARSENAME(replace(OwnerAddress,',','.'), 2),
PARSENAME(replace(OwnerAddress,',','.'), 1)
from project1..Nashvillehousing

 alter table project1.dbo.Nashvillehousing
   Add ownersplitaddress nvarchar(255);


   update project1.dbo.Nashvillehousing
   set ownersplitaddress = PARSENAME(replace(OwnerAddress,',','.'), 3)


   
 alter table project1.dbo.Nashvillehousing
   Add ownersplitcity nvarchar(255);


   update project1.dbo.Nashvillehousing
   set ownersplitcity = PARSENAME(replace(OwnerAddress,',','.'), 2)

     
 alter table project1.dbo.Nashvillehousing
   Add ownersplitstate nvarchar(255);


   update project1.dbo.Nashvillehousing
   set ownersplitstate = PARSENAME(replace(OwnerAddress,',','.'), 1)


   select * from project1..Nashvillehousing


--Change 'y' & 'N' to YES AND NO in 'SoldAsVacant' column


select Distinct(SoldAsVacant),count(SoldAsVacant)
from project1..Nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,Case when SoldAsVacant = 'N' THEN 'NO'
      WHEN SoldAsVacant = 'Y' THEN 'YES'
	  ELSE SoldAsVacant
	  END
from project1..Nashvillehousing

Update project1.dbo.Nashvillehousing
SET SoldAsVacant = Case when SoldAsVacant = 'N' THEN 'NO'
      WHEN SoldAsVacant = 'Y' THEN 'YES'
	  ELSE SoldAsVacant
	  END

--Remove Duplicates


WITH ROWNUMCTE AS(

select *, ROW_NUMBER() OVER(
     PARTITION BY ParcelID,
	 PropertyAddress,
	 SalePrice,
	 SaleDate,
	 LegalReference
  order by 
  UniqueID ) row_num

from project1.dbo.Nashvillehousing
)

 DELETE from ROWNUMCTE
  WHERE row_num >1
 -- order by PropertyAddress

 --Delete Unused Columns






 






