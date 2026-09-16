function Alert({ message, type = "warning" }) {
  return (
    <div className={`alert alert-${type}`}>
      {message}
    </div>
  );
}

export default Alert;