# CloudBurglar News

## 0.1.0
Initial release
- Provides `get_file()` for loading or downloading files directly from SharePoint or OneDrive with just a sharing link.
- - Handles both team and personal Office365 links.
- Supports loading of CSV, TSV, TXT, Excel, RDS, and RData files directly into R.
- Automatically downloads all other file types (e.g., images, scripts) to the working directory.
- Searches within folders and subfolders of document libraries, including deep/nested paths.
- Includes comprehensive unit and integration tests for both SharePoint "site" and OneDrive "personal" links.
