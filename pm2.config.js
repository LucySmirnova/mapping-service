module.exports = {
  apps: [
    {
      name: 'mapping-service-api',
      cwd: __dirname,
      script: 'node',
      args: 'src/api.js',
      watch: false,
      max_memory_restart: '500M',
      log_type: 'json',
      merge_logs: true,
    },
    {
      name: 'mapping-service-jobs',
      cwd: __dirname,
      script: 'node',
      args: 'src/jobs.js',
      watch: false,
      max_memory_restart: '1G',
      log_type: 'json',
      merge_logs: true,
    },
  ],
};
