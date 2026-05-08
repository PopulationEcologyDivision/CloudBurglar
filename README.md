# CloudBurglar

Effortlessly load or download files from Microsoft SharePoint or OneDrive into R using only a sharing link. Supports automated searching and folder recursion - no more navigating complex folder structures or downloading files by hand!

[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Features

- One function (`get_file`) for all your needs: Load or download SharePoint/OneDrive files from a sharing URL.  
- Supported file types loaded directly into R:  
   - CSV (.csv), TSV (.tsv), TXT (.txt)  
   - Excel (.xlsx, .xls)  
   - RDS and RData  
- All other file types are downloaded to your working directory.  
- Integration with Office365 sharing links for both Teams/SharePoint (`.../sites/...`) and personal OneDrive (`.../personal/...`).  
- Handles nested subfolders and duplicate file names (with warnings).

---

## Installation

Install from GitHub using one of the methods below:

remotes::install_github("PopulationEcologyDivision/CloudBurglar")
pak::pak("PopulationEcologyDivision/CloudBurglar")
devtools::install_github('PopulationEcologyDivision/CloudBurglar')
---

## Example Usage

library(CloudBurglar)

# Load a CSV from SharePoint directly into R  
df <- get_file("https://yourorg.sharepoint.com/sites/team/Shared%20Documents/data.csv")

# Load an RDS file from OneDrive  
obj <- get_file("https://yourorg-my.sharepoint.com/personal/your_name/Documents/fav_model.rds")

# Download an image to your working directory  
img_path <- get_file("https://yourorg-my.sharepoint.com/personal/your_name/Documents/photos/dog.jpg")  
# The file is now saved at 'img_path'

---

## Supported File Types

| Type           | Action                     |  
|--------------|---------------------------|  
| .csv            | Loaded as data.frame           |  
| .tsv            | Loaded as data.frame           |  
| .txt            | Loaded as data.frame           |  
| .xlsx            | Loaded as data.frame           |  
| .xls            | Loaded as data.frame           |  
| .rds            | Loaded into R              |  
| .rda/.RData | Loaded into R              |  
| others            | Downloaded to working directory  |  

---

## How It Works

- Submit a SharePoint or OneDrive sharing link for any file you have access to (either by direct link or “Copy link” from Office365).  
- `get_file()` works out the right document library, searches folders, and loads or downloads the file.  
- Loads familiar data types into your R workspace, downloads everything else.

---

## Testing

CloudBurglar is covered by unit and integration tests for major SharePoint link styles and file types.  
If you want to run the integration tests, set appropriate environment variables as described in `tests/testthat/helper-sharepoint-urls.R`.

---

## Issues & Feedback

Please submit issues, bug reports, or enhancement suggestions via GitHub issues:  
https://github.com/PopulationEcologyDivision/CloudBurglar/issues

---

## License

MIT © Mike McMahon
