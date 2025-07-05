# Connecting Your Mobile App to Local Backend

This guide explains how to connect your Flutter app running on a physical mobile device to your local backend server.

## Setup Instructions

### 1. Start Your Backend Server

Make sure your backend server is configured to listen on all network interfaces (not just localhost):

```bash
# For Laravel projects
php artisan serve --host=0.0.0.0 --port=8000

# For Node.js/Express projects
# In your server.js or app.js file, ensure you're listening on '0.0.0.0' instead of 'localhost'
app.listen(8000, '0.0.0.0', () => {
  console.log('Server running on all interfaces at port 8000');
});
```

### 2. Connect Your Mobile Device

1. Connect your mobile device to your computer via USB
2. Enable USB debugging on your device
3. Make sure your mobile device is on the same Wi-Fi network as your computer

### 3. Run the Flutter App

```bash
flutter run
```

## How It Works

The app has been configured to use your computer's local IP address (`192.168.1.4`) instead of the Android emulator's special IP (`10.0.2.2`).

If your computer's IP address changes:

1. Run `ipconfig` (Windows) or `ifconfig` (Mac/Linux) to find your computer's IP address
2. Update the IP address in `lib/core/data/data_consts.dart`

## Troubleshooting

If you can't connect to the backend:

1. **Check Firewall Settings**: Make sure your firewall allows incoming connections on port 8000
2. **Check Network**: Ensure both devices are on the same network
3. **Test Connection**: On your mobile device, open a browser and try to access `http://192.168.1.4:8000` to verify connectivity
4. **Check Backend Logs**: Look for any connection errors in your backend server logs

## Security Note

This setup is for development purposes only. When deploying to production, use proper HTTPS endpoints. 