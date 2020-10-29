# github-report-generator-action
## How to use
````
- name: Generate reports
        uses: Blackknight-Solutions/github-report-generator-action@latest
        with:
          input-folder: reports
          output-folder: reportsOutput
````

## Update Report Generator
Nuget Link: https://www.nuget.org/packages/ReportGenerator
Replace .\reportConverter\cov\ReportGenerator with reportgenerator.x.x.x\tools\netcoreapp3.0

## Update latest tag
git push --delete origin latest && git tag --delete latest && git tag -a -m "update" latest && git push origin --tags
