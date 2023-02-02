# Terraform - EKS


---

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.51.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.8.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | n/a | `string` | `"1.24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_load_balancer_controller_role_arn"></a> [aws\_load\_balancer\_controller\_role\_arn](#output\_aws\_load\_balancer\_controller\_role\_arn) | n/a |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | EKS control panel certificate in base64. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name. |

---
# DICAS PARA APRENDER COMO CONFIGURAR O AWS LOAD BALANCER CONTROLLER
1- Ir em EKS

2- Ir em Details -> Copiar o OpenID Content provider URL

3- Em IAM -> Access management -> Identity providers -> Add Provider

4- Selecionar o OpenID Connect e colocar em Provider URL, clicando após em Get thumprint

5 - Em AUDIENCE -> Para o público você deve usar sts.amazonaws.com por enquanto.

6 - Para confirmar clicar em add providers

7 - Vá em <https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/v2.4.2/docs/install>

8 - Procurar por iam_policy.json. Vamos abri-lo e clicar em raw

9- Arquivo: <https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.2/docs/install/iam_policy.json>

10 - Copiar tudo e em IAM -> Access Management -> policies -> Create Policy -> Json e colocar o conteúdo->Next, na parte Review policy digitar AWSLoadBalancerController, confirmar clicando em Create policy.

11- Ir em roles (IAM) ->create role, web identity, Identity provider escolher o oidc.eks.us-east-1.amazonaws.com/..... e em Audience sts.amazonaws.com -> next -> agoraa precisamos anexar nossa politica e vamos usar a primeira que é a que criamos AWSLoadBalancerController -> next -> Name, review and create->role details-> Em role name colocar aws-load-balancer-controller e clicar em Create Role.

12 - Verifique que foi criada a role aws-load-balancer-controller. Agora vamos precisar atualizar as relações de confiança (Trusted Relationships) para permitir que uma conta específica do k8s o use. Vams editar trust policy

13 - Não pode haver erro, pq geral erra nisso, precisamos subtituir na parte de STRINGEQUALS, aonde tem no oidc.eks... :aud -> tiramos o aud e substituimos por sub

14 - na parte com "sts.amazonaws.com" usaremos -> "system:serviceaccount:kube-system:aws-load-balancer-controller" -> esse é o valor da conta de serviço e deve estar no namespace do sistema (kube-system) do k8s, junto com o nome da conta(aws-load-balancer-controller)!

15 - Somente nesta conta será possível criar load balancers.

16 - Finalmente, clico em update policy e confirmo.
