This project is to filter row of a large file, 
when the Gene are expressed above a certain values

To extract data from GSE:
1) download the raw data from ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE93nnn/GSE93374/suppl/ 
2) Fix the file by adding the missing header ./fix_GSE_file.sh downloaded_file.txt fixed_file.txt
3) Identify which Gene to extract
4) Run extract_gene_GSE.sh -i fixed_file.txt -o output -g Gene_to_extract

The output file will contain all the column for which the Gene expression is above 5

