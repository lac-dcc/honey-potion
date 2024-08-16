# Reproducing Honey Potion Results via Docker

This folder contains a [Dockerfile](Dockerfile) to reproduce all the experiments in the Honey Potion artifact.
To create a docker image out of this docker file, you can run the following commands:

```bash
# Clone the Honey Potion repository:
#
git clone https://github.com/lac-dcc/honey-potion.git
# Move to where the Docker file is located:
#
cd honey-potion/artifact/docker/
# Build the image. This step takes about ten minutes:
#
docker build -t docker-artifact -f Dockerfile . # takes about 10 minutes
# Run RQ1: takes about 10 seconds
#
docker run --rm docker-artifact bash rq1.sh
# Run RQ2: takes about 20 seconds
#
docker run --rm docker-artifact bash rq2.sh
# Run RQ4: takes about 20 seconds
#
docker run --rm docker-artifact bash rq4.sh
# Run RQ5: takes about 20 seconds
#
docker run --rm docker-artifact bash rq5.sh
```

After running each research question, you should get the following outputs:

* [RQ1](../expected_outputs/output_rq1.txt).
* [RQ2](../expected_outputs/output_rq2.txt).
* [RQ4](../expected_outputs/output_rq4.txt).
* [RQ5](../expected_outputs/output_rq5.txt).

## Running the eBPF programs

To reproduce RQ3, it is necessary to run the eBPF programs.
In this case, you must compile them outside docker.