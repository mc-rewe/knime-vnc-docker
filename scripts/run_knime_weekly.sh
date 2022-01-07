#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
CMD="/opt/knime_4.4.0/knime -nosplash -application org.knime.product.KNIME_BATCH_APPLICATION -nosave -reset -preferences=${SCRIPT_DIR}/knime-workspace/preferences.epf"
DIR="${SCRIPT_DIR}/knime-workspace"
WORKFLOWS=(
	"Adobe/2020 BPM/01_REWE_Data_BMP"
	"Adobe/2020 BPM/02_PY_Data_BMP"
	"Adobe/2020 REWE-ECOM/2021 App Dashboard Alina/01_AppDash"
	"Adobe/2020 REWE-ECOM/2021 App Dashboard Alina/02_AppDashV2_Api14"
	"Adobe/2021_PY_KPI_Abzug/01_AdobeAPI_14"
	"Adobe/PY-Shop/PY-Shop-Adobe-ECOD-Visits-EntryPage"
	"Adobe/PY-Shop/PY-Shop-Adobe-OrdersChannel"
	"Adobe/PY-Shop/PY-Shop-Adobe-Visits"
	"CommerceTools/Commercetools-Customers"
	"CommerceTools/Commercetools-Orders"
	)

for wf in "${WORKFLOWS[@]}"; do
	${CMD} -workflowDir="${DIR}"/"${wf}";
done
