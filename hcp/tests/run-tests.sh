#!/bin/bash
# Test runner script for HyperShift automation tasks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROLE_DIR="$(dirname "$SCRIPT_DIR")"

echo "Running HyperShift automation tests..."
echo "======================================"

# Test 1: Cluster expansion logic
echo ""
echo "Test 1: Cluster expansion logic"
echo "-------------------------------"
ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/test-expand-clusters.yml" -v

# Test 2: Variable validation
echo ""
echo "Test 2: Variable validation"
echo "---------------------------"
ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/test-variables.yml" -v

# Test 3: Task flow
echo ""
echo "Test 3: Task execution flow"
echo "---------------------------"
ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/test-task-flow.yml" -v

# Test 4: Integration test
echo ""
echo "Test 4: Integration test"
echo "------------------------"
ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/test-integration.yml" -v

echo ""
echo "======================================"
echo "All tests completed successfully!"
