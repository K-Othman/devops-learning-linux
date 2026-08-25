# AWS Assignment 2 — Application Load Balancer + Auto Scaling Group

## What I Built

A highly available web tier behind an Application Load Balancer, with two private EC2 instances serving traffic, and an Auto Scaling Group (bonus) to automatically replace unhealthy or terminated instances without manual intervention.

**Architecture:**
- Reused the VPC pattern from Assignment 1, expanded to 4 subnets across 2 Availability Zones:
  - `public-subnet-1` (`10.0.0.0/24`, eu-west-2a) + `public-subnet-2` (`10.0.1.0/24`, eu-west-2b)
  - `private-subnet-1` (`10.0.16.0/20`, eu-west-2a) + `private-subnet-2` (`10.0.32.0/20`, eu-west-2b)
- Internet Gateway attached to the VPC, routed from both public subnets
- NAT Gateway (in a public subnet, with an Elastic IP) giving both private subnets outbound-only internet access
- Two route tables: `PublicRoute` (→ IGW) and `PrivateRoute` (→ NAT Gateway), each associated across both AZs
- Two security groups:
  - **ALB SG** — allows HTTP (80) from anywhere
  - **EC2 SG** — allows HTTP (80) only from the ALB SG (SG-to-SG reference, not an IP range)
- An **Application Load Balancer** (internet-facing, spanning both public subnets) with a target group performing HTTP health checks
- Two EC2 instances (`assignment-2-a`, `assignment-2-b`) in the private subnets, each running Apache via user-data, serving a simple identifying HTML page
- **Bonus — Auto Scaling Group:**
  - Launch Template capturing the AMI, instance type, key pair, EC2 security group, and the same user-data script
  - ASG spanning both private subnets, attached directly to the existing target group so new instances auto-register with the ALB
  - Capacity: Min 2 / Desired 2 / Max 4
  - Target Tracking scaling policy on average CPU utilization (target: 50%)

## Architecture Diagram

*(Insert diagram here — VPC → 2 AZs → public/private subnets → IGW/NAT → ALB → target group → ASG-managed EC2 instances)*

## Steps Taken

1. **Expanded the VPC** to 4 subnets across 2 AZs (2 public, 2 private) for high availability.
2. **Created an Internet Gateway and NAT Gateway**, attached/associated to the correct VPC and public subnet.
3. **Configured route tables** — `PublicRoute` → IGW, `PrivateRoute` → NAT Gateway — associated with the relevant subnets in both AZs.
4. **Created two security groups** — ALB SG (HTTP from anywhere) and EC2 SG (HTTP only from ALB SG).
5. **Launched two private EC2 instances** running a user-data script to install and start Apache, each serving a page identifying its own hostname.
6. **Created the Application Load Balancer** (internet-facing, spanning both public subnets), a target group with HTTP health checks, and registered both EC2 instances.
7. **Verified** the ALB's DNS name served traffic correctly, alternating between both instances on refresh.
8. **(Bonus) Built a Launch Template** replicating the manual EC2 configuration — AMI, instance type, key pair, security group, and user-data script.
9. **(Bonus) Created an Auto Scaling Group** using that template, spanning both private subnets, attached to the existing target group, with Min 2 / Desired 2 / Max 4 capacity and a target-tracking CPU scaling policy.
10. **(Bonus) Proved the ASG worked** by terminating the two original manually-created instances and watching the ASG detect the capacity drop and automatically launch replacements, which registered as healthy in the target group.

## Challenges & How I Solved Them

- **ALB subnet dropdown confusion** — the VPC selector initially looked "greyed out," which turned out to just be normal UI styling once a selection was confirmed via checkmark. Separately, ALB subnet pickers only show public subnets when "Internet-facing" scheme is selected, and the AZ dropdowns can pre-select the wrong (private) subnet by default — worth double-checking each AZ row manually.
- **`InvalidSubnetException: no internet gateway`** — the IGW had actually been created in the *default* VPC by mistake, not this project's VPC. Fixed by detaching it from the default VPC and reattaching it to the correct one.
- **Both target group instances Unhealthy** — traced via the EC2 system log (Actions → Monitor and troubleshoot → Get system log) to `yum install httpd` failing with repository timeout errors. Root cause: `PrivateRoute`'s default route (`0.0.0.0/0`) was still pointing at a NAT Gateway from a *previous, already-deleted* project — a stale reference. Created a fresh NAT Gateway and updated the route table's target.
- **Still unhealthy after the NAT fix** — even fresh instances failed the same way. Systematically ruled out the EC2 security group (fine), NACLs (fine, default allow/deny pattern), and then checked NAT Gateway CloudWatch metrics: outbound packets were leaving (Active Connections climbing) but **zero bytes were coming back** — a clear sign of asymmetric routing, i.e. traffic leaving fine but the return path broken.
- **Root cause: stale Internet Gateway reference** — the ALB itself was showing a genuine "Reachability may be impacted" warning. Investigating the VPC's Internet Gateways revealed *two* IGWs existed in its history; the currently-attached one had a different ID than the one still referenced in `PublicRoute`'s `0.0.0.0/0` route — left over from the earlier IGW detach/reattach fix. Updated the route to point at the correct, currently-attached IGW, which immediately cleared the ALB's reachability warning. Relaunched both EC2 instances one final time and health checks passed.

## What I Learned

- Load balancers and NAT Gateways depend on several interconnected pieces (route tables, IGW attachment, security groups) — a single stale ID left over from an earlier fix can cause failures that look identical to a completely different problem, so it's worth re-verifying *every* linked resource ID, not just the one you touched most recently.
- CloudWatch metrics on a NAT Gateway (bytes in/out, active connections, packets dropped) are a genuinely useful diagnostic layer above security groups and NACLs — asymmetric traffic (requests leaving, no bytes returning) points specifically at a routing problem rather than a security/firewall one.
- An Auto Scaling Group's subnet and target group settings belong at the ASG level, not the Launch Template level — the template should stay reusable and AZ-agnostic.
- Terminating instances to *prove* an ASG is working (rather than just trusting the console) is a good habit — watching the target group dip and recover with new instance IDs is much more convincing than a config screenshot alone.
- Attaching an SSH key pair to private instances is worth doing even without a bastion host present at launch time, purely for future debuggability if you ever need to add one.

## Screenshots

*(See `/screenshots` folder:)*
- *VPC/subnet overview, route tables (Public and Private) with correct IGW/NAT targets*
- *Security group inbound rules (ALB SG and EC2 SG)*
- *ALB configuration and listener*
- *Target group health checks passing — before ASG (2 manual instances)*
- *ALB DNS name serving traffic in browser, alternating between instances*
- *Launch Template summary page*
- *ASG configuration overview (subnets, target group attachment, capacity)*
- *Target group with all 4 healthy targets (2 manual + 2 ASG-launched)*
- *ASG Activity tab showing scaling/replacement history*
- *Target group back to 2 healthy after terminating the manual instances — new instance IDs proving the ASG replaced them*
- *CloudWatch/ASG Monitoring tab showing CPU utilization feeding the scaling policy*