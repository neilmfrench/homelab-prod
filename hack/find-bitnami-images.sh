#!/usr/bin/env bash
# find-bitnami-images.sh
# Lists Bitnami images running in a Kubernetes cluster.
# Usage:
#   ./find-bitnami-images.sh                 # summary + detailed (all namespaces)
#   ./find-bitnami-images.sh --summary       # summary only
#   ./find-bitnami-images.sh --detailed      # detailed only
#   ./find-bitnami-images.sh -- kube-args    # pass flags to kubectl after "--"
#
# Examples:
#   ./find-bitnami-images.sh -- --context myctx
#   ./find-bitnami-images.sh --detailed -- -n production

set -euo pipefail

show_summary=true
show_detailed=true
kubectl_args=()

# Parse simple flags (everything after "--" is passed to kubectl)
while (( $# )); do
  case "$1" in
    --summary)   show_detailed=false ;;
    --detailed)  show_summary=false ;;
    --help|-h)
      sed -n '1,25p' "$0"
      exit 0
      ;;
    --)
      shift
      kubectl_args=("$@")
      break
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
  shift
done

# Grab all pods as JSON (respect user-supplied kubectl args)
pods_json="$(kubectl get pods -A -o json "${kubectl_args[@]}" 2>/dev/null || true)"

# If empty, either no access or no pods
if [[ -z "$pods_json" || "$pods_json" == "null" ]]; then
  echo "No pods found or unable to fetch pods (check kubectl context/permissions)." >&2
  exit 1
fi

# jq program that extracts (ns, pod, container, image) for any container type
jq_extract='
  .items[] as $p
  | $p.metadata.namespace as $ns
  | $p.metadata.name as $pod
  | (($p.spec.containers // []) + ($p.spec.initContainers // []) + ($p.spec.ephemeralContainers // []))[]
  | {ns: $ns, pod: $pod, c: .name, image: .image}
'

# Bitnami match (covers docker.io/bitnami, ghcr.io/bitnami, bitnamilegacy, or bare "bitnami/..."):
# - case-insensitive
# - matches: "bitnami/" or "bitnamilegacy/" as a repo path, with optional registry prefix
jq_filter_bitnami='
  select(
    (.image | ascii_downcase)
    | test("(^|[^a-z0-9._-])bitnami(/)"; "i")            # .../bitnami/...
      or test("(^|[^a-z0-9._-])bitnamilegacy(/)"; "i")   # .../bitnamilegacy/...
      or test("^ghcr\\.io/bitnami/"; "i")                # ghcr.io/bitnami/...
  )
'

if $show_summary; then
  echo "==> Bitnami images (unique) and usage counts"
  echo "count  image"
  echo "$pods_json" \
    | jq -r "$jq_extract | $jq_filter_bitnami | .image" \
    | sort \
    | uniq -c \
    | awk '{printf "%5d  %s\n", $1, $2}'
  echo
fi

if $show_detailed; then
  echo "==> Detailed usage (namespace | pod | container | image)"
  echo "NAMESPACE  POD  CONTAINER  IMAGE"
  echo "$pods_json" \
    | jq -r "$jq_extract | $jq_filter_bitnami | [.ns, .pod, .c, .image] | @tsv" \
    | awk -F'\t' '{printf "%-10s %-40s %-20s %s\n", $1, $2, $3, $4}'
fi
