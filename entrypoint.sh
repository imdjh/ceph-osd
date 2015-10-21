#!/bin/bash
set -e

: ${CLUSTER:=ceph}
: ${WEIGHT:=1.0}
#######
# OSD #
#######

OSD_ID=$(ls /var/lib/ceph/osd|awk -F- '{print $2 }')
OSD_PATH=/var/lib/ceph/osd/${CLUSTER}-${OSD_ID}

if [ ! -e ${OSD_PATH}/keyring ]; then
  # bootstrap OSD
  mkdir -p ${OSD_PATH}
  ceph --cluster ${CLUSTER} osd create
  ceph-osd --cluster ${CLUSTER} -i ${OSD_ID} --mkfs
  ceph --cluster ${CLUSTER} auth get-or-create osd.${OSD_ID} osd 'allow *' mon 'allow profile osd' -o ${OSD_PATH}/keyring
  ceph --cluster ${CLUSTER} osd crush add ${OSD_ID} ${WEIGHT} root=default host=$(hostname -s)
  ceph-osd --cluster ${CLUSTER} -i ${OSD_ID} -k ${OSD_PATH}/keyring
  ceph --cluster ${CLUSTER} -w
fi

# start OSD
echo "alias ceph='ceph --cluster ${CLUSTER}'" >> /root/.bashrc
ceph-osd --cluster ${CLUSTER} -i ${OSD_ID} -k ${OSD_PATH}/keyring
ceph --cluster ${CLUSTER} -w