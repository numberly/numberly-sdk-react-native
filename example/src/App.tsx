import * as React from 'react';

import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
} from 'react-native';

import { Numberly, NumberlyEventType } from 'react-native-numberly-sdk';


export default function App() {
  const [installationID, setInstallationID] = React.useState<string | null | undefined>("");
  const [areNotificationsEnabled, setAreNotificationsEnabled] = React.useState<boolean | null | undefined>(false);
  const [deviceToken, setDeviceToken] = React.useState<string | null | undefined>("");
  const [notificationResponse, setNotificationResponse] = React.useState<string>("");

  React.useEffect(() => {
    Numberly.user.installationID().then(setInstallationID);

    Numberly.push.areNotificationsEnabled().then(setAreNotificationsEnabled);

    Numberly.addListener(NumberlyEventType.PushTokenReceived, (event) => {
      console.log("Push token: ", event.token);
      setDeviceToken(event.token);
    })

    Numberly.addListener(NumberlyEventType.PushNotificationResponse, (event) => {
      setNotificationResponse(JSON.stringify(event));
    })
  }, []);

  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView>
        <ScrollView contentInsetAdjustmentBehavior="automatic" style={styles.scrollView}>
          <View style={styles.header}>
            <Text style={styles.headerTitle}>Numberly</Text>
            <Text style={styles.headerSubtitle}>React Native - Example</Text>
          </View>
          <View>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Installation ID</Text>
              <Text style={styles.sectionDescription}>
                {installationID}
              </Text>
            </View>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Are notifications enabled</Text>
              <Text style={styles.sectionDescription}>
                {areNotificationsEnabled?.toString().toUpperCase()}
              </Text>
            </View>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Token</Text>
              <Text style={styles.sectionDescription}>{deviceToken}</Text>
            </View>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Notification Response</Text>
              <Text style={styles.sectionDescription}>
              {notificationResponse}
              </Text>
            </View>
            <View style={styles.footer}/>
          </View>
        </ScrollView>
      </SafeAreaView>
    </>
  );
}

const styles = StyleSheet.create({
  scrollView: {
    paddingBottom: 20,
  },
  header: {
    paddingBottom: 20,
    paddingTop: 64,
    paddingHorizontal: 32,
    backgroundColor: '#00A6B6',
  },
  headerTitle: {
    fontSize: 40,
    fontWeight: '600',
    textAlign: 'center',
    color: '#FFF',
  },
  headerSubtitle: {
    fontSize: 18,
    textAlign: 'center',
    color: '#FFF',
    marginTop: 10,
  },
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
    color: '#595959',
  },
  footer: {
    height: 20,
  },
});
