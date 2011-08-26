#!/bin/ksh

PKG_LIST_FILE="$(dirname $(whence $0))/PACKAGES_LIST"
REPO_URL_MAIN="http://172.23.251.108:10000/"
REPO_URL_LGCY="http://pkg.openindiana.org/legacy"


echo "Content-type: text/xml"
echo

case "$REQUEST_METHOD" in
  POST|post)
    cat <<EOF
<!DOCTYPE auto_install SYSTEM "file:///usr/share/auto_install/ai.dtd">
<auto_install>
  <ai_instance name="default" auto_reboot="true">
    <target>
         <target_device>
         	<disk>
	         	<disk_keyword key="boot_disk" />
          <partition name="1" action="delete" />
          <partition name="2" action="delete" />
          <partition name="3" action="delete" />
          <partition name="4" action="delete" />
	  <partition name="0" action="create" part_type="191" />
	  <slice name="0" action="create" is_root="true" force="true" />
        </disk>
 	</target_device>
    </target>
    <software>
      <source>
        <publisher name="openindiana.org">
          <origin name="${REPO_URL_MAIN}"/>
        </publisher>
      </source>
      <source>
        <publisher name="opensolaris.org">
          <origin name="${REPO_URL_LGCY}"/>
        </publisher>
      </source>
      <software_data action="install" type="IPS">
EOF
    while read PKGN; do
      echo "        <name>pkg:/${PKGN}</name>"
    done < "$PKG_LIST_FILE"
    cat <<EOF
      </software_data>
    </software>
    <sc_embedded_manifest name="AI">
      <!-- <?xml version='1.0'?>
      <!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">
      <service_bundle type="profile" name="system configuration">
        <service name="system/install/config" version="1" type="service">
          <instance name="default" enabled="true">
            <property_group name="user_account" type="application">
              <propval name="login" type="astring" value="jack"/>
              <propval name="password" type="astring" value="9Nd/cwBcNWFZg"/>
              <propval name="description" type="astring" value="default_user"/>
              <propval name="shell" type="astring" value="/usr/bin/bash"/>
              <propval name="uid" type='count' value='101'/>
              <propval name="gid" type='count' value='10'/>
              <propval name="type" type="astring" value="normal"/>
              <propval name="roles" type="astring" value="root"/>
            </property_group>

            <property_group name="root_account" type="application">
                <propval name="password" type="astring" value="9Nd/cwBcNWFZg"/>
                <propval name="type" type="astring" value="role"/>
            </property_group>

            <property_group name="other_sc_params" type="application">
              <propval name="timezone" type="astring" value="GMT"/>
              <propval name="hostname" type="astring" value="openindiana"/>
            </property_group>
          </instance>
        </service>
        <service name="system/console-login" version="1" type="service">
          <property_group name="ttymon" type="application">
            <propval name="terminal_type" type="astring" value="sun"/>
          </property_group>
        </service>

        <service name='system/keymap' version='1' type='service'>
          <instance name='default' enabled='true'>
            <property_group name='keymap' type='system'>
              <propval name='layout' type='astring' value='US-English'/>
            </property_group>
          </instance>
        </service>

        <service name="network/physical" version="1" type="service">
          <instance name="nwam" enabled="true"/>
          <instance name="default" enabled="false"/>
        </service>
      </service_bundle>
      -->
    </sc_embedded_manifest>
    <add_drivers>
      <!--
	    Driver Updates: This section is for adding driver packages to the
            boot environment before the installation takes place.  The
            installer can then access all devices on the system.  The
            packages installed in the boot environment will also be installed
            on the target.

            A <search_all> entry performs a search for devices which are
            missing their drivers.  A repository publisher and location
            may be specified, and that repository and its database will
            be used.  If no publisher and location is specified, the
            configured repositories will be used.
            (See pkg publisher command.)  If <addall> is specified as
            "true", then drivers the database says are third-party drivers
            will be added like all others; otherwise third-party drivers
            will not be added.

                <search_all addall="true">
                    <source>
                        <publisher name="openindiana.org">
                            <origin name="http://pkg.openindiana.org/stable"/>
                        </publisher>
                    </source>
                </search_all>

            <software> entries are user-provided specifications of packages
            needed in order to perform the install.  types are P5I, SVR4, DU.
            A <software_data> action of "noinstall" inhibits adding to target.

            P5I: A pkg(5) P5I file, full path is in the source/publisher/origin.
            Path may be to a local file or an http or ftp specification.
                <software>
                    <source>
                        <publisher>
                            <origin
				name=
		"http://pkg.openindiana.org/stable/p5i/0/driver/firewire.p5i"/>
                        </publisher>
                    </source>
		    <software_data type="P5I"/>
                </software>

            SVR4: An SVR4 package spec. The source/publisher/origin corresponds
            to the directory containing the packages.  The 
	    software/software_data/name refers tp the package's top level
	    directory or the package's datastream file.

                <software>
                    <source>
                        <publisher>
                            <origin name="/export/package_dir"/>
                        </publisher>
                    </source>
                    <software_data type="SVR4">
                        <name>my_disk_driver.d</name>
                    </software_data>
                </software>

            DU: An ITU (Install Time Update) or Driver Update image.
            The source/publisher/origin refers to the path just above the 
	    image's DU directory (if expanded) or the name of the .iso image.  
	    All packages in the image will be added.

                <software>
                    <source>
                        <publisher>
                            <origin name="/export/duimages/mydriver.iso"/>
                        </publisher>
                    </source>
                    <software_data type="DU"/>
                </software>	
      -->
      <search_all/>
    </add_drivers>
  </ai_instance>
</auto_install>
EOF
    ;;
  *) # GET and all other methods
    cat <<'EOF'
<CriteriaList>
  <Version Number="0.5"/>
</CriteriaList>
EOF
    ;;
esac

