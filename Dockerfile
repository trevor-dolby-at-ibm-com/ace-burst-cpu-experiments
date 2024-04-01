FROM cp.icr.io/cp/appc/ace:12.0.11.0-r1

# docker build -t tdolby/experimental:ace-burst-cpu  .
# docker run --rm -ti -e LICENSE=accept tdolby/experimental:ace-burst-cpu


ADD start-poll-for-cpu-change.sh /home/aceuser/ace-server/start-poll-for-cpu-change.sh
ADD poll-for-cpu-change.sh /home/aceuser/ace-server/poll-for-cpu-change.sh

ENTRYPOINT ["bash", "-c", "source /opt/ibm/ace-12/server/bin/mqsiprofile && bash /home/aceuser/ace-server/start-poll-for-cpu-change.sh && IntegrationServer --work-dir /home/aceuser/ace-server"]
