/*
 Cleaning Data in SQL Queries

 */

 Select *
 from SQLPortfoliaProject..NashvilleHousing

 -- Standardize Date Format

 Select SaleDateConverted, Convert(Date,SaleDate)
 from SQLPortfoliaProject..NashvilleHousing

 Update NashvilleHousing
 SET SaleDate = Convert(Date,SaleDate)

 ALTER TABLE NashvilleHousing
 Add SaleDateConverted Date;

 Update NashvilleHousing
 SET SaleDateConverted = Convert(Date,SaleDate)

 --Populate Property Address data

  Select Propertyaddress 
 from SQLPortfoliaProject..NashvilleHousing
 Where Propertyaddress is null

 Select *
 from SQLPortfoliaProject..NashvilleHousing
 Where Propertyaddress is null

 Select *
 from SQLPortfoliaProject..NashvilleHousing
 order by ParcelID

 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 from SQLPortfoliaProject..NashvilleHousing a
 Join SQLPortfoliaProject..NashvilleHousing b
      on a.ParcelID = b.ParcelID 
	  AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from SQLPortfoliaProject..NashvilleHousing a
 Join SQLPortfoliaProject..NashvilleHousing b
      on a.ParcelID = b.ParcelID 
	  AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns(Address, City, State)

Select PropertyAddress
from SQLPortfoliaProject..NashvilleHousing

Select 
SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyAddress)) as Address
from SQLPortfoliaProject..NashvilleHousing



 ALTER TABLE NashvilleHousing
 Add PropertySplitAddress Nvarchar(255);

 Update NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


  ALTER TABLE NashvilleHousing
 Add PropertySplitCity Nvarchar(255) ;

 Update NashvilleHousing
 SET PropertySplitCity = SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyAddress))

Select * 
from SQLPortfoliaProject..NashvilleHousing



Select OwnerAddress
from SQLPortfoliaProject..NashvilleHousing
Where OwnerAddress is not null

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from SQLPortfoliaProject..NashvilleHousing
Where OwnerAddress is not null


 ALTER TABLE NashvilleHousing
 Add OwnerSplitAddress Nvarchar(255);

 Update NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


  ALTER TABLE NashvilleHousing
 Add OwnerSplitCity Nvarchar(255) ;

 Update NashvilleHousing
 SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


   ALTER TABLE NashvilleHousing
 Add OwnerSplitState Nvarchar(255) ;

 Update NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


 Select *
 from SQLPortfoliaProject..NashvilleHousing
 Where OwnerSplitState is not null


 --Change Y and N to Yes and No in "Sold as Vacant" column

 Select distinct(SoldAsVacant), count(SoldAsVacant)
 from SQLPortfoliaProject..NashvilleHousing
 Group by SoldAsVacant
 Order by 2


  Select SoldAsVacant,
  Case when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   else SoldAsVacant
	   END
 from SQLPortfoliaProject..NashvilleHousing

 Update NashvilleHousing
 SET SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   else SoldAsVacant
	   END


--Romove Duplicates

WITH RowNumCTE As(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from SQLPortfoliaProject..NashvilleHousing
)

Select *
from RowNumCTE
where row_num > 1
order by PropertyAddress



--Delete Unused Columns


Select *
from SQLPortfoliaProject..NashvilleHousing

ALTER TABLE SQLPortfoliaProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE SQLPortfoliaProject..NashvilleHousing
DROP COLUMN SaleDate