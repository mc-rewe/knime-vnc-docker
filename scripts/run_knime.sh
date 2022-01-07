#!/bin/bash

# Get command line args
KNIME_EXEC=$1
WORKSPACE=$2

CMD_OPTS="-nosplash -application org.knime.product.KNIME_BATCH_APPLICATION -nosave -reset -preferences=${WORKSPACE}/preferences.epf"

WORKFLOWS=(
	"CyreenExportSales" 
	"Adobe/2020 REWE-ECOM/01_OrdersLastTouch"
	)

for wf in "${WORKFLOWS[@]}"; do
    echo ""
    echo "Running ${KNIME_EXEC} ${CMD_OPTS} -workflowDir="${WORKSPACE}"/"${wf}""
    echo ""
	${KNIME_EXEC} ${CMD_OPTS} -workflowDir="${WORKSPACE}"/"${wf}";
done
