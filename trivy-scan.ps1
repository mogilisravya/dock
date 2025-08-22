param(
    [string]$ImageName,
    [string]$OutputFile = "trivy-report.html"
)

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock `
    -v "$pwd\reports:/reports" `
    aquasec/trivy:latest `
    image --format template --template "@contrib/html.tpl" `
    -o "/reports/$OutputFile" "$ImageName"
