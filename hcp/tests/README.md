# HyperShift Automation Tests

This directory contains tests for the HyperShift automation Ansible role.

## Test Structure

- `test-expand-clusters.yml` - Tests the cluster expansion logic when using the `count` parameter
- `test-variables.yml` - Tests variable validation and structure
- `test-task-flow.yml` - Tests task execution flow with mocked dependencies
- `test-integration.yml` - Integration tests for the complete workflow
- `run-tests.sh` - Test runner script
- `inventory` - Ansible inventory file for tests

## Running Tests

### Run all tests
```bash
make test
```

### Run individual tests
```bash
make test-expand    # Test cluster expansion
make test-vars      # Test variables
make test-flow      # Test task flow
make test-integration  # Integration tests
```

### Run tests manually
```bash
cd hcp/tests
bash run-tests.sh
```

Or run individual test playbooks:
```bash
ansible-playbook -i inventory test-expand-clusters.yml
ansible-playbook -i inventory test-variables.yml
ansible-playbook -i inventory test-task-flow.yml
ansible-playbook -i inventory test-integration.yml
```

## Test Coverage

The tests cover:
- ✅ Cluster expansion with `count` parameter
- ✅ Single cluster definitions (no count)
- ✅ Variable structure validation
- ✅ Domain constant verification
- ✅ Task execution flow
- ✅ Integration scenarios

## Requirements

- Ansible installed
- No external dependencies required (tests use mocked data)
- Tests run against localhost (no actual cluster creation)
