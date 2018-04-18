#!/usr/bin/env bats

@test "Should stop running container" {
    # given (started container)
    docker run -d --name stopping_victim alpine tail -f /dev/null

    # when (trying to stop container)
    run pumba stop /stopping_victim

    # then (pumba exited successfully)
    [ $status -eq 0 ]

    # and (container has been stopped)
    run bash -c "docker inspect stopping_victim | grep Running"
    [[ $output == *"false"* ]]

    # cleanup
    docker rm -f stopping_victim || true
}

@test "Should (re)start a previously stopped container" {
    # given (stopped container)
    docker run -d --name starting_victim alpine tail -f /dev/null

    # when (trying to stop container)
    run pumba stop --restart=true --duration=5s /stopping_victim

    # then (pumba exited successfully)
    [ $status -eq 0 ]

    # and (container has been (re)started)
    run bash -c "docker inspect starting_victim | grep Running"
    [[ $output == *"true"* ]]

    # cleanup
    docker rm -f starting_victim || true
}