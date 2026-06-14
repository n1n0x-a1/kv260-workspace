package util

import "os"

// Service endpoint addresses.
// Override via environment variables:
//   NINOCTL_XMUTIL_ADDR  - xmutil-server on KV260  (default: 192.168.123.112:8080)
//   NINOCTL_VITIS_ADDR   - vitis-server on Master   (default: 192.168.123.210:8082)
//   NINOCTL_APP_ADDR     - app-server on KV260       (default: 192.168.123.112:8084)

func getEnvOrDefault(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func XmutilAddr() string {
	return getEnvOrDefault("NINOCTL_XMUTIL_ADDR", "192.168.123.112:8080")
}

func VitisAddr() string {
	return getEnvOrDefault("NINOCTL_VITIS_ADDR", "192.168.123.210:8082")
}

func AppAddr() string {
	return getEnvOrDefault("NINOCTL_APP_ADDR", "192.168.123.112:8084")
}
