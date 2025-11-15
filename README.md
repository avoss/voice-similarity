```java
  private static String voiceName(Voice voice) {
    return switch(voice.getName()) {
      case M1 -> "onyx";
      case M2 -> "fable";
      case M3 -> "echo";
      case F1 -> "nova";
      case F2 -> "shimmer";
      default -> throw new IllegalArgumentException("Unknown voice name: " + voice.getName());
    };
  }

```