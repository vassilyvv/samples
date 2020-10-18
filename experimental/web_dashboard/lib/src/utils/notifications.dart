String trimNotificationCount(int count) {
  return count > 99 ? "99+" : count.toString();
}