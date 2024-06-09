
SELECT * FROM NashvilleHousing


--Cleaning up the data step by step

--1- Standarized by Changing the Y and N in the SoldAsVacant to Yes and No

--a- check the steps by creating a new column with the needed information
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'N' THEN 'No'
	 WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 ELSE SoldAsVacant
END 
FROM NashvilleHousing



--b- Apply the changes in this column to the actual column

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						ELSE SoldAsVacant
				   END 

--c- check if it worked
SELECT DISTINCT SoldAsVacant FROM NashvilleHousing

---------------------------------------------------------------------------------------------------------


--2- Checking on date columns

SELECT SaleDate FROM NashvilleHousing
ORDER BY SaleDate

--Dates are standarized in this sheet

---------------------------------------------------------------------------------------------------------

--3- Determine the reason for the missing propertyAddress information
Select *
	From NashvilleHousing
	order by ParcelID

--from viewing this we can determine that the Null values happen when we have the same property sold more than one
-- in this case we can copy data for the propertyaddress from pervious lines with the same paracelId

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

--after checking with a SELECT statment, we can udpdate with an UPDATE 

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

--Check if the update worked properly

SELECT PropertyAddress FROM NashvilleHousing WHERE PropertyAddress IS NULL 
--No NULL values

---------------------------------------------------------------------------------------------------------

--4- Check if we have any duplicate columns

--Do the check on rows that have the same values in the following columns (ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference)
WITH Duplicates AS(
Select *,
	ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num
From NashvilleHousing)

DELETE FROM Duplicates
WHERE row_num > 1

--Check how many rows are remaining after deleting the duplicate rows to make sure everything was done correctly
SELECT * FROM NashvilleHousing
--56477 total rows before deleting
--104 duplicate rows
--56373 Remaining rows after removing duplicates

---------------------------------------------------------------------------------------------------------

--5- Standardize and break out both address columns

SELECT PropertyAddress, OwnerAddress FROM NashvilleHousing

--Split both columns, the firt into street address and City, and the oweners address into Street address, City and State.
Select
PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2)
,PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)
From NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing

--Create new columns with the new data.


ALTER TABLE NashvilleHousing
Add PropertyStreetAddress Nvarchar(255);

Update NashvilleHousing
SET PropertyStreetAddress = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add PropertyCity Nvarchar(255);

Update NashvilleHousing
SET PropertyCity = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)

ALTER TABLE NashvilleHousing
Add OwnerStreetAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

--Check if all the new columns are added
SELECT * FROM NashvilleHousing

---------------------------------------------------------------------------------------------------------

--6- Lastly we need to delete the columns that we split up 

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

--Check one last time on the last version of the sheet
SELECT * FROM NashvilleHousing