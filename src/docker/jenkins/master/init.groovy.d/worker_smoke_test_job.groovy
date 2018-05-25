import jenkins.model.*

Jenkins.instance.createProjectFromXML("worker_test", new ByteArrayInputStream(
'''<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.17">
  <actions/>
  <description>Test for validating the worker docker image</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps@2.45">
    <script>node(&apos;master&apos;) {
    def customImage
   stage(&quot;build docker&quot;)
   {
      sh(&apos;&apos;&apos;
#make a docker file
cat &lt;&lt; EOF &gt; ./Dockerfile
FROM ubuntu:14.04
CMD [&quot;/bin/bash&quot;, &quot;-c&quot;, &quot;sleep 300&quot;]
EOF
&apos;&apos;&apos;)
      customImage = docker.build(&quot;foo:latest&quot;)
   }
   stage(&quot;test that docker!&quot;)
   {
       sh(&apos;&apos;&apos;
       #Make a gemfile
cat &lt;&lt;EOF &gt; Gemfile
source &apos;https://rubygems.org&apos;

gem &apos;docker-api&apos;, :require =&gt; &apos;docker&apos;
gem &apos;serverspec&apos;
EOF

bundle install

cat &lt;&lt; EOF &gt; ./Dockerfile_spec.rb
require &quot;serverspec&quot;
require &quot;docker&quot;

#build a serverspec file:
describe &quot;Dockerfile&quot; do
  before(:all) do
    image = Docker::Image.build_from_dir(&apos;.&apos;)

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  it &quot;installs the right version of Ubuntu&quot; do
    expect(os_version).to include(&quot;Ubuntu 14&quot;)
  end

  def os_version
    command(&quot;lsb_release -a&quot;).stdout
  end
end
EOF


rspec ./Dockerfile_spec.rb
       &apos;&apos;&apos;)
   }
   stage(&apos;Play with that docker&apos;)
   {
      docker.image(&quot;foo:latest&quot;).withRun() {
          sh(&apos;docker ps&apos;)
      }
   }
}

</script>
    <sandbox>true</sandbox>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
'''.bytes
))