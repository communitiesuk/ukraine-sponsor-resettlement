#!/bin/bash
RAILS_ENV=test rake db:prepare && rake db:migrate && rake

# NB: The container will be destroyed when the tests complete,
# which means that the coverage report will be lost.
# If you want the coverage report, you can keep the container alive by doing
# RAILS_ENV=test rake db:prepare && rake db:migrate && rake && tail -f /dev/null
# instead; ie comment out line 2 above and uncomment the line directly above (line 8).
# (tail -f /dev/null is a benign way of keeping the container active).
# When the tests have completed you can copy the covereage report to your
# docker host's local filesystem by doing
# docker cp <container ID or name>:/app/coverage <destination path on host>
# on the host.
# For example, to copy to the coverage report to the current working directory on the host:
# docker cp ukraine-sponsor-resettlement-test-1:/app/coverage .
