# Elasticsearch Test Server

Requires: Docker, Homebrew

## Instructions

Run `elasticsearch_run.sh` with an optional index name as the first argument. If no index name is provided, `default_index` will be used.

```
$ chmod +x ./elasticsearch_run.sh
$ ./elasticsearch_run.sh <index_name>
```

This script does a few things:

1. Pulls the latest version of the Elasticsearch Docker image, if not already present on disk.
2. Runs a Docker container based off the image, if not already running.
3. Creates the index specified, if it doesn't already exist.
4. Tails the logs of the container for the specified index and prints newly inserted messages as they arrive (from changefeed or other).
