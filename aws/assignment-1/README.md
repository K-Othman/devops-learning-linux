# AWS Assignment 1 — VPC & Networking

## What I Built

A custom VPC built from scratch with public and private subnets, full internet routing, and secure access to private resources via a bastion host.

**Architecture:**
- 1 VPC (`10.0.0.0/16`)
- 1 Public Subnet (`10.0.0.0/20`) + 1 Private Subnet (`10.0.16.0/21`)
- Internet Gateway attached to the VPC, routed from the public subnet
- NAT Gateway (in the public subnet, with an Elastic IP) giving the private subnet outbound-only internet access
- Two custom route tables: `PublicRoute` (→ IGW) and `PrivateRoute` (→ NAT Gateway)
- 3 EC2 instances: a public web instance, a private instance, and a dedicated bastion host
- Security groups scoped per instance, following least-privilege access

## Architecture Diagram

*(Insert diagram here — e.g. draw.io export showing VPC → subnets → IGW/NAT → EC2 instances)*

## Steps Taken

1. **Created the VPC** with CIDR block `10.0.0.0/16`.
2. **Created two subnets** inside the VPC — one public, one private — each with a non-overlapping CIDR range.
3. **Created and attached an Internet Gateway** to the VPC.
4. **Created a NAT Gateway** in the public subnet, associated with an Elastic IP, to give the private subnet outbound internet access without exposing it to inbound traffic.
5. **Configured route tables:**
   - `PublicRoute`: routes `0.0.0.0/0` → Internet Gateway, associated with the public subnet.
   - `PrivateRoute`: routes `0.0.0.0/0` → NAT Gateway, associated with the private subnet.
6. **Launched EC2 instances:**
   - `assignment1-public-ec2` in the public subnet, with a public IP.
   - `assignment1-private-ec2` in the private subnet, no public IP.
   - `assignment1-bastion-host` in the public subnet, dedicated solely to secure SSH access.
7. **Configured security groups:**
   - **Public EC2 SG** — allows SSH (22) and HTTP (80) only from my own IP.
   - **Bastion SG** — allows SSH (22) only from my own IP.
   - **Private EC2 SG** — allows SSH (22) only from the bastion's security group (SG-to-SG reference, not an IP range).
8. **Verified connectivity end-to-end:**
   - SSH'd from my local machine into the public EC2 instance directly.
   - SSH'd into the bastion host using agent forwarding (`ssh -A`), then hopped from the bastion into the private instance using its private IP — confirming the private instance is unreachable directly from the internet but reachable through the bastion.

## Challenges & How I Solved Them

- **NAT Gateway "Availability mode" confusion** — the console offered a newer "Regional" mode alongside the traditional "Zonal" mode. Since the assignment expects the classic single-AZ NAT Gateway tied to a specific public subnet, I selected Zonal.
- **Silent SSH timeout to the private instance via the bastion** — no error, just a hang followed by a timeout. Root-caused through methodical elimination: checked route tables (correct), security group rules (correct), NACLs (default, correct), bastion outbound rules (found and fixed — was completely empty, blocking all outbound traffic from the bastion). After fixing that, still timed out.
- **IPv4 vs IPv6 mismatch** — eventually traced the remaining timeout to my own terminal connecting over IPv6, while my security group's SSH rule only allowlisted my IPv4 address. Two valid configurations that silently didn't match. Fixed by forcing IPv4 with `ssh -4`, and could alternatively be solved by adding an IPv6 rule to the security group.
- **Stale security group reference** — after recreating the bastion host partway through (had to relaunch with the correct key pair), the private instance's security group was still referencing the *old*, terminated bastion's SG ID rather than the new one. Fixed by updating the SSH rule's source to the current bastion's SG.

## What I Learned

- A subnet's public/private status is determined entirely by its route table association, not by any inherent subnet property.
- Security groups are stateful and allow-only; NACLs are stateless and support explicit allow/deny — useful to check both when debugging connectivity.
- "Looks correctly configured" and "actually works" are not the same thing in networking — dual-stack (IPv4/IPv6) environments can silently break connections that look fine on both sides in isolation.
- Reusing an existing key pair across instances is standard practice; SSH agent forwarding is the secure way to hop through a bastion without ever copying private keys onto it.
- NAT Gateways and Elastic IPs bill hourly regardless of use — worth tearing down NAT Gateways (and releasing unattached EIPs) between work sessions on a learning project, while EC2 instances can just be stopped rather than terminated to preserve configuration.

## Screenshots

*(See `/screenshots` folder — VPC details, subnets, route tables with routes, IGW, NAT Gateway, Elastic IP, EC2 instances, security group inbound rules, and a successful SSH session into the public instance and through the bastion.)*
