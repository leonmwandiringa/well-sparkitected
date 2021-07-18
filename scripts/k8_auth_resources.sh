#!/bin/bash

echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
echo "----------------- LTM - Infrastructure automation ------------------"
echo "-------- initial terraform state management and state locks --------"
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------
"
CURRENTFOLDER=`pwd`

ROLESTR=`terraform output | grep eks_node_group_role_arn`
$ROLESTR=( $(IFS="=" echo "$ROLESTR") )
EKS_ROLE_ARN=`echo $ROLESTR | sed -e 's/^"//' -e 's/"$//'`
aws eks --region us-east-2 update-kubeconfig --name well-sparkitected_dev_cluster
sed -i "s/{{EKS_ROLE_ARN}}/$EKS_ROLE_ARN/g" "$CURRENTFOLDER/k8-resources/core/well-sparkitected-auth.configmap.yaml"