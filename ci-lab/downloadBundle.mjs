// Generic replica of a "pick the artifact by name from the triggering run" helper.
// Note what is absent: any check that the triggering run came from a trusted branch or
// repository, and any integrity check on the archive.
export async function downloadBundle({ github, context }) {
  const fs = await import('fs')
  const artifacts = await github.rest.actions.listWorkflowRunArtifacts({
    owner: context.repo.owner,
    repo: context.repo.repo,
    run_id: context.payload.workflow_run.id,
  })
  const match = artifacts.data.artifacts.find((artifact) => artifact.name === 'storybook-static')
  if (!match) throw new Error('no artifact named storybook-static')
  const download = await github.rest.actions.downloadArtifact({
    owner: context.repo.owner,
    repo: context.repo.repo,
    artifact_id: match.id,
    archive_format: 'zip',
  })
  fs.writeFileSync('storybook-static.zip', Buffer.from(download.data))
}
