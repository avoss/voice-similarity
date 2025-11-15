import sys
import numpy as np
from pathlib import Path
from resemblyzer import VoiceEncoder, preprocess_wav

if len(sys.argv) < 3:
    print("Usage: python find_most_similar_voice.py OLD.wav NEW1.wav NEW2.wav ...")
    sys.exit(1)

old_path = Path(sys.argv[1])
new_paths = [Path(p) for p in sys.argv[2:]]

encoder = VoiceEncoder()

# Compute embedding for old TTS audio
old_wav = preprocess_wav(old_path)
old_emb = encoder.embed_utterance(old_wav)

results = []

for p in new_paths:
    wav = preprocess_wav(p)
    emb = encoder.embed_utterance(wav)

    # cosine similarity
    sim = np.dot(old_emb, emb) / (np.linalg.norm(old_emb) * np.linalg.norm(emb))
    results.append((p.name, float(sim)))

# Sort by similarity (descending)
results.sort(key=lambda x: x[1], reverse=True)

print("Most similar voices:")
for name, score in results:
    print(f"{name}: similarity = {score:.4f}")
