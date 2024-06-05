-- Membersihkan data menggunakan SQL
SELECT	*
FROM	NashvilleHousing

-- 1. Meng-standarisasikan format tanggal
SELECT	SaleDateConverted,
		CONVERT(Date, SaleDate)
FROM	NashvilleHousing

ALTER TABLE NashvilleHousing
ADD	SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- 2. Mengisi property address yang kosong
-- Query dibawah akan me-replace property address yang kosong dengan menggunakan ParcelID yang sama dan terdapat alamat didalamnya. Join 2 tabel yang sama untuk mendapatkan ParcelID yang alamatnya kosong di dalam satu tabel lalu nantinya akan di replace oleh ParcelID yang memiliki alamat di tabel yang lain.
SELECT	nh1.ParcelID,
		nh1.PropertyAddress,
		nh2.ParcelID,
		nh2.PropertyAddress,
		ISNULL(nh1.PropertyAddress, nh2.PropertyAddress)
FROM	NashvilleHousing nh1
JOIN	NashvilleHousing nh2
ON		nh1.ParcelID = nh2.ParcelID AND nh1.[UniqueID ] <> nh2.[UniqueID ]
WHERE	nh1.PropertyAddress IS NULL

-- Mengupdate property address yang kosong menggunakan alamat yang sama dengan ParcelID di dalam tabel pertama
UPDATE	nh1
SET		PropertyAddress = ISNULL(nh1.PropertyAddress, nh2.PropertyAddress)
FROM	NashvilleHousing nh1
JOIN	NashvilleHousing nh2
ON		nh1.ParcelID = nh2.ParcelID AND nh1.[UniqueID ] <> nh2.[UniqueID ]
WHERE	nh1.PropertyAddress IS NULL

-- 3. Memecah alamat menjadi kolom individu (Address, City, State)
SELECT	PropertyAddress
FROM	NashvilleHousing

SELECT	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS 'Address',
		SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS 'Address'
FROM	NashvilleHousing


ALTER TABLE NashvilleHousing
ADD	PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD	PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

-- Owner Address
SELECT OwnerAddress
FROM NashvilleHousing

SELECT	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
		PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
		PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM	NashvilleHousing

--Address
ALTER TABLE NashvilleHousing
ADD	OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

--City
ALTER TABLE NashvilleHousing
ADD	OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

--State
ALTER TABLE NashvilleHousing
ADD	OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM NashvilleHousing

-- 4. Mengubah Y dan N menjadi Yes dan No di "Sold as Vacant"
SELECT	DISTINCT(SoldAsVacant),
		COUNT(SoldAsVacant)
FROM	NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT	SoldAsVacant,
		CASE 
			WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
		END
FROM	NashvilleHousing

BEGIN TRAN
UPDATE	NashvilleHousing
SET		SoldAsVacant = CASE 
							WHEN SoldAsVacant = 'Y' THEN 'Yes'
							WHEN SoldAsVacant = 'N' THEN 'No'
							ELSE SoldAsVacant
						END
ROLLBACK

-- Menghapus duplikasi
WITH RowNumCTE AS(
SELECT	*,
		ROW_NUMBER() OVER(
		PARTITION BY	ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						ORDER BY UniqueID
		) row_num
FROM	NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- 5. Menghapus kolom yang tidak terpakai
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


SELECT *
FROM NashvilleHousing