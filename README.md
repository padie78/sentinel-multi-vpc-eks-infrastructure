## 🚀 Deep Dive: How I handled Deployment

The goal here was a "zero-touch" workflow. I moved away from manual `kubectl` tweaks towards a **GitOps-lite** approach using GitHub Actions.

* **OIDC over Static Keys:** Storing AWS Access Keys in GitHub Secrets is a huge risk. Instead, I set up **IAM OIDC Identity Providers**. This lets GitHub assume a temporary IAM role via a secure token, strictly scoped to this repo. No permanent keys.
* **The Context Switch:** The workflow handles two separate `kubeconfig` files. It first hits the Backend cluster to grab the necessary metadata, then flips over to the Gateway cluster to push the proxy configuration.
* **Rolling Updates:** To avoid downtime during config changes, I used `kubectl rollout restart`. This ensures Nginx pods pick up the new `ConfigMap` (with the fresh Backend DNS) following a standard rolling strategy.

---

## 🌐 Networking: The Internal Backbone

### Cross-VPC Peering (Hub-and-Spoke)
The main challenge was cluster-to-cluster talk without hitting the public internet.
* **Isolation:** By using **VPC Peering**, the Backend VPC stays "dark"—no IGW routes for incoming public traffic.
* **Route Integrity:** I manually mapped the route tables so traffic for the `10.x.x.x` sibling range goes straight through the peering tunnel. Internal traffic stays on the AWS global backbone, period.

### Connecting the Proxy to the Backend
Static IPs are a nightmare in dynamic environments. My fix was **Dynamic DNS Injection**:
1.  **NLB Setup:** The Backend service spins up an Internal Network Load Balancer.
2.  **Metadata Scraping:** The CI/CD pipeline uses `aws eks` and `elbv2` APIs to snatch the NLB's DNS name on the fly.
3.  **The 'sed' Patch:** I used a `sed` command as a lightweight template engine to swap a placeholder in `nginx-proxy-config.yaml` with the actual live DNS.
4.  **Self-healing:** This decouples the tiers completely. You can kill and recreate the Backend cluster, and the Gateway will fix itself on the next deploy.

---

## 🛡 Security: Layered Defense

I went with a **Defense-in-Depth** approach, securing both the "walls" and the "doors."

* **Infrastructure (Security Groups):** The Backend nodes live behind a Security Group that explicitly drops everything not coming from the Gateway VPC's CIDR.
* **Cluster (NetworkPolicies):** Kubernetes is way too open by default. I moved to a **Zero-Trust** model.
* **Default Deny:** I applied a "Deny All" ingress policy to the backend namespace.
* **Targeted Holes:** I created a specific policy to only allow traffic on port `5678` from pods with the `app: gateway` label. If it's not the proxy, it's not getting in.

---

## ⚖️ Trade-offs: Why I made these calls

In a 3-day sprint, "perfect" is the enemy of "shipped." Here’s the reality of the decisions:
* **KMS & CloudWatch:** Setting up full KMS encryption for EBS and EKS Secrets adds a lot of IAM complexity. To keep the demo error-free and fast, I left these out.
* **State Management:** I’m using local state for Terraform. In a real production environment, I’d obviously use S3/DynamoDB, but for a solo tech test, local is just faster to iterate.
* **The "Manual" Factor:** AWS can be slow to propagate Peering routes. I added a couple of manual SG rules to ensure connectivity during initial testing instead of fighting Terraform race conditions for hours.

---

## 💰 Cost & Efficiency

Keeping the AWS bill low was a priority:
* **T3.Mediums:** These are the "sweet spot." 2 vCPUs and 4GB RAM is the bare minimum to keep system pods (like `coredns` and `aws-node`) from hitting OOM errors.
* **Shared NAT Gateways:** NATs are expensive (~$32/mo). I used one per VPC instead of one per AZ, cutting fixed costs by half without losing private subnet access.
* **Internal NLB:** I chose NLB over ALB for the internal tier. It’s cheaper, handles TCP passthrough better, and offers the low latency needed for proxying.

---

## 🔮 Roadmap: Next Steps

If I had another week, here is what I’d tackle:
1.  **Service Mesh (mTLS):** Deploy **Istio** or **Linkerd** to encrypt traffic *inside* the peering tunnel.
2.  **Cert-Manager:** Automate Let's Encrypt certificates for the Gateway to get proper HTTPS.
3.  **Observability:** A Prometheus/Grafana stack. Right now, it works, but I want to *see* the latency.
4.  **True GitOps:** Switch from GitHub Actions to **ArgoCD**. No more `kubectl` in the pipeline—just the cluster syncing itself from Git.