#!/bin/bash

PSQL=/awips2/psql/bin/psql
DIR=`dirname $0`
${PSQL} -U awips -d ncep -f ${DIR}/addNcepNwxAdminMessageGpTable.sql
