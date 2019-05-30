declare var process: Process;

interface Process {
    env: Env
}

interface Env {
    ENDPOINT_HOST: string
}

interface GlobalEnvironment {
    process: Process
}