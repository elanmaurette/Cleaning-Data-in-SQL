/* 
Cleaning Data in SQL Queries
*/

Select * 
From [Portfolio Project]..Nashville$

-- First we want to standarize date format of the column SaleDate
Select SaleDate, CONVERT(Date, SaleDate) as SaleDateConverted
From [Portfolio Project]..Nashville$

Update [Portfolio Project]..Nashville$
SET SaleDate = CONVERT(Date, SaleDate) 

ALTER TABLE Nashville$
Add SaleDateConverted Date;

Update Nashville$
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Second we are going to edit the Property Adress data. We find there are fields with Null Values.
-- We are going to use Selfjoin  to populate the adress to corresponding ParcelID.

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..Nashville$ a
JOIN [Portfolio Project]..Nashville$ b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..Nashville$ a
JOIN [Portfolio Project]..Nashville$ b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking adress  into Individual columns (Adress, City, State)


Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From [Portfolio Project]..Nashville$

ALTER TABLE Nashville$
Add PropertySplitAddress Nvarchar(255);

Update Nashville$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville$
Add PropertySplitCity Nvarchar(255);

Update Nashville$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select *
From [Portfolio Project]..Nashville$


-- Splitting Owner Address into 3 Columns (Address, City, State) 

Select PARSENAME(REPLACE(OwnerAddress, ',','.'),1),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
From [Portfolio Project]..Nashville$

Alter table Nashville$
Add OwnerSplitAdress Nvarchar(255);

Update Nashville$
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


Alter table Nashville$
Add OwnerSplitCity Nvarchar(255);

Update Nashville$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

Alter table Nashville$
Add OwnerSplitState Nvarchar(255);

Update Nashville$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1) 


-- We have different names in the "SoldAsVacant" column, we will try to Change all the names into "Yes" or "No"

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END
From [Portfolio Project]..Nashville$

Update Nashville$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END

--- Remove duplicates present in the Database

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio Project]..Nashville$
)
Delete
From RowNumCTE
Where row_num > 1


-- Delete unused columns (HalfBath)

Select *
From [Portfolio Project]..Nashville$

ALTER TABLE [Portfolio Project]..Nashville$
DROP COLUMN HalfBath