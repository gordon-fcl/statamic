# GitHub Actions Deployment Setup

## Required GitHub Secrets

Add these in your repository: Settings → Secrets and variables → Actions → New repository secret

1. **VPS_HOST** - Your VPS IP address or domain
2. **VPS_USER** - SSH username (e.g., `root` or your user)
3. **VPS_SSH_KEY** - Private SSH key for authentication
4. **VPS_PATH** - Full path to Statamic on VPS (e.g., `/opt/statamic`)
5. **CONTAINER_NAME** - Podman container name (e.g., `statamic_app`)

## Generating SSH Key for Deployment

On your local machine:

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/github_deploy
```

Add the public key to your VPS:

```bash
ssh-copy-id -i ~/.ssh/github_deploy.pub user@your-vps-ip
```

Copy the private key content for GitHub secret:

```bash
cat ~/.ssh/github_deploy
```

## Testing the Deployment

1. Add the secrets to GitHub
2. Push to main branch
3. Check Actions tab in GitHub to monitor deployment
4. Verify files updated on VPS and cache cleared

## What Gets Deployed

- All content from `site/*` directory
- Blog articles, collections, config, views, etc.
- Excludes: `.git`, `node_modules`, vendor files (already on server)

## Manual Deployment

If needed, deploy manually:

```bash
rsync -avz --exclude 'node_modules' --exclude 'vendor' --exclude '.git' \
  ./site/ user@vps-ip:/path/to/statamic/
```
