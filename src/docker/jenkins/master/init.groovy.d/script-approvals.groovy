import jenkins.model.Jenkins;
import jenkins.model.*;
import org.jenkinsci.plugins.scriptsecurity.scripts.*;

def scriptApproval = ScriptApproval.get()

scriptApproval.approveSignature('method net.sf.json.JSONArray join java.lang.String')

scriptApproval.save()
