#http://geosoft.no/development/android.html

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home
export ANDROID_HOME=/Users/jamesfolk/Library/Android/sdk
export DEV_HOME=`pwd`

#rm -rf src
#rm -rf res
#rm -rf obj
#rm -rf lib
#rm -rf bin
#rm -rf docs

#mkdir src
#mkdir src/com
#mkdir src/com/mycompany
#mkdir src/com/mycompany/package1
#mkdir res
#mkdir res/drawable
#mkdir res/layout
#mkdir res/values
#mkdir obj
#mkdir lib
#mkdir bin
#mkdir docs

echo '<?xml version="1.0" encoding="utf-8"?> 
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.mycompany.package1" android:versionCode="1" android:versionName="1.0"> 
 
    <uses-permission android:name="android.permission.INTERNET"/> 
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/> 
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/> 
 
 
    <application android:icon="@drawable/mylogo" android:label="@string/myApplicationName"> 
        <activity android:name="com.mycompany.package1.HelloAndroid" android:label="@string/myApplicationName"> 
        <intent-filter> 
            <action android:name="android.intent.action.MAIN" /> 
            <category android:name="android.intent.category.LAUNCHER" /> 
        </intent-filter> 
        </activity> 
    </application> 
 
</manifest>
' > AndroidManifest.xml

echo '
package com.mycompany.package1;

import android.app.Activity;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TextView;

public class HelloAndroid extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView textView = new TextView(this);

        String text = getResources().getString(R.string.helloText);
        textView.setText(text);

        setContentView(textView);
    }
}
' > src/com/mycompany/package1/HelloAndroid.java

echo '
package com.mycompany.package1;
class HelloWorld {
 
static {
System.loadLibrary("HelloWorld");
}

private native void print();

public static void main(String[] args) {
new HelloWorld().print();
}
}
' > src/com/mycompany/package1/HelloWorld.java
echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="myApplicationName">Android Test Program</string>
    <string name="helloText">Hello, world!</string>
</resources>' > res/values/strings.xml

${ANDROID_HOME}/build-tools/23.0.3/aapt \
    package \
    -v \
    -f \
    -m \
    -S ${DEV_HOME}/res \
    -J ${DEV_HOME}/src \
    -M ${DEV_HOME}/AndroidManifest.xml \
    -I "${ANDROID_HOME}/platforms/android-25/android.jar"


${JAVA_HOME}/bin/javac \
    -verbose \
    -d "${DEV_HOME}/obj" \
    -classpath "${ANDROID_HOME}/platforms/android-25/android.jar:${DEV_HOME}/obj" \
    -sourcepath ${DEV_HOME}/src ${DEV_HOME}/src/com/mycompany/package1/*.java

javah -jni \
    -o ${DEV_HOME}/cpp/HelloWorld.h \
    -classpath "${ANDROID_HOME}/platforms/android-25/android.jar:${DEV_HOME}/obj" \
    com.mycompany.package1.HelloWorld

#${ANDROID_HOME}/build-tools/23.0.3/dx \
#    --dex \
#    --verbose \
#    --output=${DEV_HOME}/bin/classes.dex \
#    ${DEV_HOME}/obj \
#    ${DEV_HOME}/lib
#
#${ANDROID_HOME}/build-tools/23.0.3/aapt \
#    package \
#    -v \
#    -f \
#    -M ${DEV_HOME}/AndroidManifest.xml \
#    -S ${DEV_HOME}/res \
#    -I ${ANDROID_HOME}/platforms/android-25/android.jar \
#    -F ${DEV_HOME}/bin/AndroidTest.unsigned.apk \
#    ${DEV_HOME}/bin
#
#${JAVA_HOME}/bin/keytool \
#    -genkeypair \
#    -validity 10000 \
#    -dname "CN=company name, OU=organisational unit, O=organisation, L=location, S=state, C=country code" \
#    -keystore ${DEV_HOME}/AndroidTest.keystore \
#    -storepass password \
#    -keypass password \
#    -alias AndroidTestKey \
#    -keyalg RSA \
#    -v
#
#${JAVA_HOME}/bin/jarsigner \
#    -verbose \
#    -keystore ${DEV_HOME}/AndroidTest.keystore \
#    -storepass password \
#    -keypass password \
#    -signedjar ${DEV_HOME}/bin/AndroidTest.signed.apk \
#    ${DEV_HOME}/bin/AndroidTest.unsigned.apk \
#    AndroidTestKey
#
#
##${ANDROID_HOME}/platform-tools/adb \
##    -d \
##    install ${DEV_HOME}/bin/AndroidTest.signed.apk
#
#${JAVA_HOME}/bin/javadoc \
#    -verbose \
#    -d ${DEV_HOME}/docs \
#    -sourcepath ${DEV_HOME}/src \
#    -classpath "${ANDROID_HOME}/platforms/android-25/android.jar:${DEV_HOME}/obj" \
#    -author \
#    -package \
#    -use \
#    -splitIndex \
#    -version \
#    -windowtitle 'AndroidTest' \
#    -doctitle 'AndroidTest' \
#    ${DEV_HOME}/src/com/mycompany/package1/*.java
#
