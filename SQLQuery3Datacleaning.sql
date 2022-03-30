

  --Cleaning data in SQL queries

  SELECT SaleDateConverted,CONVERT(Date,SaleDate)
  FROM NashvilleHousing;

 
 ALTER TABLE NashvilleHousing
 ADD SaleDateConverted Date;

 
 UPDATE NashvilleHousing			
 SET SaleDateConverted= CONVERT(Date,SaleDate)

 --Populate Porperty Address data

SELECT 
a.ParcelID,
a.PropertyAddress,
b.ParcelID,
b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)

 FROM NashvilleHousing a
 JOIN NashvilleHousing b
 ON a.ParcelID=b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
 WHERE a.PropertyAddress Is NULL;
 
 UPDATE a
  SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM NashvilleHousing a
 JOIN NashvilleHousing b
 ON a.ParcelID=b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
 WHERE a.PropertyAddress Is NULL;

 --Breaking Address in individual column(Address, City, State)
 
  SELECT 
  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
    SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))AS Address,
  FROM NashvilleHousing
  

 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress NVARCHAR (255);
 
 UPDATE NashvilleHousing			
 SET PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

 ALTER TABLE NashvilleHousing
 ADD PropertySplitCity NVARCHAR (255);

 UPDATE NashvilleHousing			
 SET PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

 


  SELECT 
    PARSENAME(REPLACE(OwnerAddress,',','.'),3),
    PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
  FROM NashvilleHousing

  ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress NVARCHAR (255);
 
 UPDATE NashvilleHousing			
 SET OwnerSplitAddress=  PARSENAME(REPLACE(OwnerAddress,',','.'),3)

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity NVARCHAR (255);

 UPDATE NashvilleHousing			
 SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)

  ALTER TABLE NashvilleHousing
 ADD OwnerSplitState NVARCHAR (255)

 UPDATE NashvilleHousing			
 SET OwnerSplitState= 	PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Change 'Y' and 'N' as 'Yes' and 'No' 'SoldAsVacant' field

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE when SoldAsVacant='Y'THEN 'Yes'
	 when SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM  NashvilleHousing


 UPDATE NashvilleHousing			
 SET SoldAsVacant= 	CASE when SoldAsVacant='Y'THEN 'Yes'
	 when SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END


--Remove Duplicates

WITH RowNumCTE AS(
SELECT*,
	Row_Number()OVER
	(PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num 

FROM NashvilleHousing)
--ORDER BY ParcelID

SELECT * 
FROM RowNumCTE
WHERE row_num >1 




--Delete unused column

SELECT*
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN 
OwnerAddress,
TaxDistrict,
PropertyAddress,
SaleDate;
