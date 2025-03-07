#USERNAME="mathiseng"
#PACKAGE="podman-project-webservice"
#GITHUB_TOKEN="some_read_only_token" 
NAMESPACE="default"  # Change to your namespace
HELM_CHART_DIR="./webservice-chart"  # Change to your Helm chart directory

# Fetch the latest image tag
LATEST_TAG=$(curl -s -H "Authorization: Bearer some_read_only_token" https://api.github.com/users/mathiseng/packages/container/podman-project-webservice/versions | jq -r '.[0].metadata.container.tags[0]')

if [ -z "$LATEST_TAG" ]; then
  echo "Error: Could not fetch the latest image tag."
  exit 1
fi

echo "Latest image tag: $LATEST_TAG"

# Update Helm values with the latest tag
helm upgrade webservice-chart $HELM_CHART_DIR \
  --namespace $NAMESPACE \
  --set deployment.image.tag=$LATEST_TAG

if [ $? -eq 0 ]; then
  echo "Helm deployment updated successfully with tag: $LATEST_TAG"
else
  echo "Error: Helm deployment failed."
  exit 1
fi