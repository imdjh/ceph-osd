# DOCKER-VERSION 1.0.0
# 
# Ceph OSD
#
#  USAGE NOTES:
#    * OSD_ID (numeric identifier for this OSD; obtain from `ceph osd create`)
#
# VERSION 0.0.2

FROM index.alauda.cn/alexander/ceph-base:0.94.4
MAINTAINER Seán C McCord "ulexus@gmail.com"

# Expose the ceph OSD port (6800+, by default)
EXPOSE 6800

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ADD entrypoint.sh /root/entrypoint.sh

RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]