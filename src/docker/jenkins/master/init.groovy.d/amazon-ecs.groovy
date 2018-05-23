import com.cloudbees.jenkins.plugins.amazonecs.*

def cloudName = "worker-cluster"

def templateName = "docker-template"
def label = "docker"
def imageName = "scos-jenkins-worker"
def fileSystemRoot = "/home/jenkins"
def softMemoryReservationMB = 256
def hardMemoryReservationMB = 0
def cpuCount = 1
def priviledgedContainer = false
def mountPoints = [new ECSTaskTemplate.MountPointEntry("docker-socket", "/var/run/docker.sock", "/var/run/docker.sock", false) ]
def containerUser = null
def logDriverOptions = []
def environments = []
def extraHosts = []
def portMappings = []

def dockerTemplate = new ECSTaskTemplate(templateName, label, imageName, fileSystemRoot,
                                         hardMemoryReservationMB, softMemoryReservationMB, cpuCount,
                                         priviledgedContainer, containerUser, logDriverOptions, 
                                         environments, extraHosts, mountPoints, portMappings)



def jenkins = Jenkins.get()
def slaveTimeoutSeconds = 10

// credentials and cluster arn are dummied here and must be provided by an admin through ${jenkins_url}/configure
def cloud = new ECSCloud(cloudName, [dockerTemplate], "credentialId", "cluster arn", "us-east-2", jenkins.rootUrl, slaveTimeoutSeconds)

def clouds = jenkins.clouds

clouds.findAll { it.name.equals(cloudName) }
		.each { clouds.remove(it) }

jenkins.clouds.add(cloud)