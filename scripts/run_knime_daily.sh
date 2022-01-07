#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
CMD="/opt/knime_4.4.0/knime -nosplash -application org.knime.product.KNIME_BATCH_APPLICATION -nosave -reset -preferences=${SCRIPT_DIR}/knime-workspace/preferences.epf"
DIR="${SCRIPT_DIR}/knime-workspace"
WORKFLOWS=(
	"CyreenExportSales" 
	"Adobe/2020 REWE-ECOM/01_OrdersLastTouch"
	)

for wf in "${WORKFLOWS[@]}"; do
	${CMD} -workflowDir="${DIR}"/"${wf}";
done
