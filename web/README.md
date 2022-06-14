# La météo du numérique
Ce projet a été initié par l'académie de Rennes et vise à répondre aux besoins suivants :
- disposer d'un outil pour informer en temps réel nos usagers sur l'état de nos services,
- réduire le nombre de tickets auprès de la plateforme d'assistance.

# Table of contents
1. [Principe](#principe)
	1. [Supported input connectors](#supported-input-connectors)
	2. [Supported output connectors](#supported-output-connectors)
	3. [Data transformation](#data-transformation)
	4. [Overall principle](#overall-principle)
		1. [No templating or XSLT templating](#no-templating-or-xslt-templating)
		2. [With Freemarker templating](#with-freemarker-templating)
2. [Packaging](#packaging)
3. [Installation](#installation)
	1. [Deployment overview](#deployment-overview)
	2. [Control machine preparation](#control-machine-preparation)
		1. [Installation pre-requisites](#installation-pre-requisites)
		2. [Preparation](#preparation)
			1. [Multiple environments configuration](#multiple-environments-configuration)
			2. [Credentials protection](#credentials-protection)
	3. [Deployment on hosts](#deployment-on-hosts)
		1. [Deployment pre-requisites](#deployment-pre-requisites)
		2. [How to deploy an ETL version on a host](#how-to-deploy-an-etl-version-on-a-host)
			1. [Deploy a version on a host](#deploy-a-version-on-a-host)
			2. [Deploy a snapshot multiple times](#deploy-a-snapshot-multiple-times)
			3. [Install the Alambic utility files](#install-the-alambic-utility-files)
		3. [Rollback a deployed version on a host](#rollback-a-deployed-version-on-a-host)
		4. [How to uninstall the ETL on a host](#how-to-uninstall-the-etl-on-a-host)
		5. [How to deploy an addon version on a host](#how-to-deploy-an-addon-version-on-a-host)
	4. [Execution on a host](#execution-on-a-host)
		1. [How to run a job](#how-to-run-a-job)
		2. [How to run a shell script](#how-to-run-a-shell-script)
	5. [How to get the execution report](#how-to-get-the-execution-report)
4. [Usage](#usage)
	1. [Job definition XML file skeleton](#job-definition-xml-file-skeleton)
		1. [Description](#description)
	2. [Job definition examples](#job-definition-examples)
		1. [With no templating](#with-no-templating)
		2. [With a XSLT templating](#with-a-xslt-templating)
		3. [With a Freemarker templating](#with-a-freemarker-templating)
	3. [Utility functions](#utility-functions)
5. [Monitoring](#monitoring)
	1. [Display dashboard](#display-dashboard)
	2. [Monitor a remote Alambic instance](#monitor-a-remote-alambic-instance)

# Principe


## Overall principle

### No templating or XSLT templating
![No templating or XSLT](images/Capture-ETL-XSLT.png "No templating or XSLT")

### Description
The ETL product iterates over the input entries, apply the transformation directives and load the data into a target.

Optionally, a XSLT template may be used to transform each entry from the source. An intermediate file is then built for each transformed entry and loaded on the target.

When no XSLT template is used, an intermediate file can be used instead, including variables. These variables  (acting as _placeholders_) will be resolved with the attributes coming from each input entry.
This intermediate file is then loaded inside the target.

A specific syntax allows to execute treatments at runtime, when the intermediate file is loaded.
As an example :
- request a LDAP server,
- control the unicity of a value inside a LDAP server based-on multiple criteria / attributes,
- generate a unique identifier,
- cypher data,
- normalise data (deals with accentuation, upper or lower case, non-word characters...).

### With Freemarker templating
![With Freemarker templating](images/Capture-ETL-Freemarker.png "With Freemarker templating")

### Description
As depicted above, two jobs collaborates to extract the input data, apply the transformation directives then load into the target.

The first job uses the Freemarker templating engine to extract the data and apply the transformation directives.
The ETL product provides the Freemarker template engine with Java API in order to request multiples sources, join entries and consolidate them.
The intermediate file produced contains all the entries to load into the target unlike in the previous mode where the intermediate file dealed with one source entry iteration only.

The second job aims to load the intermediate file entries inside the target after having executed treatments on the fly.

This mode offers the benefit to :
- make possible the qualification of the intermediate file before it is loaded,
- use the features from the powerful Freemarker templating engine.

# Packaging
Run the command ```$ mvn clean install``` to package the project and install it within the local Maven repository.

Two artefacts are built :
- ***alambic-product-<version>.zip*** : contains the Alambic product executable jar,
- ***alambic-devops-<version>.zip*** : contains the Ansible scripts for installation & execution.
